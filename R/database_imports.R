#' Puts data in a list of filenames to import
#'
#' it does this yada yada.
#' @importFrom magrittr %>%
#' @param filepath path where CSVs are stored
#' @param db_type Type of database - any one of (crash, vehicle, person)
#' @param years_selected Year(s) of data c("20", "21")
#' @param years_selected_old Year(s) of data c("16")
#' @param selected_columns Columns to select, CRSHNMBR,CRSHDATE are automatically included
#'
#' @return data frame of db_type
#' @export
#'
#' @examples
#' get_db_data(filepath = "C:/CSV/csv_from_sas/fst/", db_type = "crash",
#' years_selected = c("17","18"), years_selected_old = c("15", "16"))
get_db_data <-
  function(filepath,
           db_type,
           years_selected,
           years_selected_old,
           selected_columns = c("CRSHTIME")) {
    if (length(years_selected) != 0) {
    data_years = paste(years_selected, db_type, sep = "") # combines crashes with years to select data
    df = paste(filepath, data_years, ".fst", sep = "") # select data in specified location/format
    df_new <-
      do.call(dplyr::bind_rows, lapply(df, read_fst_for_new_db, selected_columns)) # reads and combines data
    # this imports data, keeps only crashes in public areas
    # Then it relabels column names
    df_new
    }
    if (length(years_selected_old) != 0) {
    data_years_old = paste(years_selected_old, db_type, sep = "") # combines crashes with years to select data
    df_old = paste(filepath, data_years_old, ".fst", sep = "") # select data in specified location/format
    df_old <-
      do.call(dplyr::bind_rows, lapply(df_old, read_fst_for_old_db)) %>% dplyr::filter(
        ACCDSVR != 'NON-REPORTABLE',
        ACCDLOC == 'INTERSECTION' |
          ACCDLOC == 'NON-INTERSECTION'
      ) %>% dplyr::select(-ACCDLOC)
    df_old <-
      data.table::setnames(
        df_old,
        c(
          "ACCDNMBR",
          "ACCDDATE",
          "ACCDMTH",
          "ACCDTIME",
          "ACCDSVR",
          "ACCDTYPE"
        ),
        c(
          "CRSHNMBR",
          "CRSHDATE",
          "CRSHMTH",
          "CRSHTIME_GROUP",
          "CRSHSVR",
          "CRSHTYPE"
        )
      ) # %>% relabel_CRSHSVR_old_db()
    df_old
    }

    dplyr::bind_rows(df_new, df_old)
  }



# Read the first row to find which columns actually exists, returns columns that exist.
read_cols <- function(file_name, colsToKeep) {
  header <- fst::read_fst(file_name, to = 1)
  # Keeps only columns found in the df
  subset(colsToKeep, colsToKeep %in% colnames(header))
}

# This reads fst files and converts data types so they all match for all db
read_fst_for_new_db <- function(file_to_read, col_to_select) {
  col_to_select <- union(c("CRSHNMBR", "CRSHDATE","CRSHSVR"),col_to_select)
  # I'm using mutate_at and any_of to change class type only if column exists
  found_columns <- read_cols(file_to_read, col_to_select)
  fst::read_fst(file_to_read, as.data.table = TRUE, columns = found_columns) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::any_of(
      c("MCFLNMBR",
        "RECDSTAT",
        "MUNICODE",
        "CNTYCODE",
        "POPCLASS",
        "FARSFATL",
        "INSSTA",
        "MCFLNMBR",
        "BACCODE",
        "ARBGDPLT",
        "OT",
        "OF",
        "ALCFCTR",
        "OWNRTYP",
        "INSURED",
        "TKBSPRMT",
        "NTFYDATE",
        "DIDJUR",
        "ALCSUSP",
        "DRUGSUSP",
        "CARRID"
      )
    )), as.character) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::starts_with("HAZCLSS")), as.character)
  # mutate_at(dplyr::vars(any_of("NTFYDATE")), ymd)
}

read_fst_for_old_db <- function(file_to_read) {
  fst::read_fst(file_to_read, as.data.table = TRUE) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::any_of(c(
      "URBRURAL", "STPTLNB", "ZIPCODE", "NTFYDATE", "TKBSPRMT", "MCFLNMBR", "DOCTNMBR"
    ))), as.character) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::starts_with("DMGAR")), as.character) %>%
    # mutate_at(dplyr::vars(any_of("NTFYDATE")), ymd) %>%
    # Format county name so they are not all in caps
    dplyr::mutate_at("CNTYCODE", stringr::str_to_title) %>%
    dplyr::mutate(
      CNTYCODE = ifelse(CNTYCODE == "Fond Du Lac", "Fond du Lac", CNTYCODE))
  # ZIPCODE = ifelse(is.na(ZIPCODE), "0", ZIPCODE)
}
