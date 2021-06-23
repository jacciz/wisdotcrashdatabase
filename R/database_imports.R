#' Import crash, vehicle, person from crash database
#'
#' This imports all data based on crash db type, years selected, and columns
#' selected. It combines old and new crash data into a single dataframe. It
#' renames columns of the old db to match db and renames some variables, such as
#' CRSHSVR, to match new db. Note: if an old db is imported, all columns will be
#' automatically selected.
#' @importFrom magrittr %>%
#' @param filepath path where FSTs are stored (must all be in this folder)
#' @param db_type Type of database - any one of "crash", "vehicle", or "person"
#' @param years Year(s) of new db data c("20", "21"). Must be "17" or higher.
#' @param years_old Year(s) of old db data c("16"). Must be "16" or lower.
#' @param columns Columns to be imported. For the new db these columns will
#'   always be imported (if applicable): "CRSHNMBR", "CRSHDATE", "CNTYCODE
#'   ,"CRSHSVR", "UNITNMBR", "ROLE","VEHTYPE","WISINJ". Columns with multiples,
#'   like DRVRPC and ANMLTY, only the first part without the number should be
#'   inputted. For old db, all columns will be imported.
#'   If columns = c(), all columns will be selected.
#'
#' @return dataframe of either crash, vehicle or person. crsh_year column.
#' @export
#'
#' @examples
#' import_db_data(filepath = "C:/CSV/csv_from_sas/fst/", db_type = "crash",
#'   years_old = c("15", "16"), years = c("17","18"),  columns = c("DRVRPC"))
#' \dontrun{import_db_data(fst_path, "person", years = "20")}
import_db_data <-
  function(filepath,
           db_type,
           years_old = c(),
           years = c(),
           columns = c()) {
    # If years were selected, open new db data
    if (length(years) != 0) {
    data_years = paste(years, db_type, sep = "") # combines crashes with years to select data
    df = paste(filepath, data_years, ".fst", sep = "") # select data in specified location/format
    df_new <-
      do.call(dplyr::bind_rows, lapply(df, read_fst_for_new_db, columns)) # reads and combines data
    # this imports data, keeps only crashes in public areas
    # Then it relabels column names
    df_new
    } else {
      df_new = data.frame()
    }
    # If years_old was selected, open old db data
    if (length(years_old) != 0) {
    data_years_old = paste(years_old, db_type, sep = "") # combines crashes with years to select data
    df_old = paste(filepath, data_years_old, ".fst", sep = "") # select data in specified location/format
    df_old <-
      do.call(dplyr::bind_rows, lapply(df_old, read_fst_for_old_db)) %>% dplyr::filter(
        .data$ACCDSVR != 'NON-REPORTABLE',
        .data$ACCDLOC == 'INTERSECTION' |
          .data$ACCDLOC == 'NON-INTERSECTION'
      ) %>% dplyr::select(-.data$ACCDLOC)
    df_old <-
      data.table::setnames(
        # Rename columns to match with new db
        df_old,
        skip_absent=TRUE,  # skip if column does not exist
        c(
          "ACCDNMBR",
          "ACCDDATE",
          "ACCDMTH",
          "ACCDTIME",
          "ACCDHOUR",
          "ACCDSVR",
          "ACCDTYPE",
          "AGE",
          "INJSVR",
          "ALCFLAG",
          "DRUGFLAG"
        ),
        c(
          "CRSHNMBR",
          "CRSHDATE",
          "CRSHMTH",
          "CRSHTIME_GROUP",
          "CRSHHOUR",
          "CRSHSVR",
          "CRSHTYPE",
          "AGE_GROUP",
          "WISINJ",
          "ALCSUSP",
          "DRUGSUSP"
        )
      ) %>% relabel_CRSHSVR_old_db() %>%  # for person relabel_WISINJ_old_db())
      data.table::as.data.table()
    if (db_type == "person") {
      df_old <- df_old %>% relabel_WISINJ_old_db()
      df_old
    }
    df_old
    } else {
      df_old = data.frame()
    }
    dplyr::bind_rows(df_new, df_old) %>%
      dplyr::mutate(year = lubridate::year(.data$CRSHDATE))
  }

# Read the first row to find which columns actually exists, returns columns that exist.
# If columns = c(), all columns are returned
read_cols <- function(file_name, colsToKeep) {
  header <- fst::read_fst(file_name, to = 1)
  if (is.null(colsToKeep)) {
    return(colnames(header))
  } else {
    colsToKeep <- union(c("CRSHDATE","CNTYCODE", "CRSHSVR","UNITNMBR", "ROLE","VEHTYPE","WISINJ"), colsToKeep) # Tack this on
    # Returns only columns found in the df
    return(subset(colsToKeep, colsToKeep %in% colnames(header)))}
}

# This reads fst files and converts data types so they all match for all db
read_fst_for_new_db <- function(file_to_read, col_to_select) {

  # If specific columns were selected, find which match in the database
  if (length(col_to_select) > 0) {
    # Get all names for data that may be in multiple column
    columns_with_multiples <-
      subset(
        col_to_select,
        grepl( # Columns that have multiples
          "WTCOND|RDCOND|ENVPC|RDWYPC|ADDTL|CLSRSN|ANMLTY|DMGAR|VEHPC|HAZPLAC|HAZNMBR|HAZCLSS|HAZNAME|HAZFLAG|DRVRDS|DRUGYT|DRVRRS|DRVRPC|DNMFTR|STATNM|NMTACT|NMTSFQ|PROTGR|CITISS|CITNM|STATDS|STATSV|RSTRCT|CITNM",
          col_to_select
        )
      )

    # If columns with multiples were found, make a list of all values, tack them onto the end. i.e. DRVRPC01, DRVRPC02, etc.
    if (length(columns_with_multiples) != 0) {
      # This adds the '01' to '20' to the end of each matching column
      get_all_names <-
        sapply(columns_with_multiples,
               paste0,
               formatC(seq(1, 20), width = 2, flag = "0")) %>% as.character()

      col_to_select <- Reduce(union,
             list(c("CRSHNMBR"),
                  col_to_select,
                  get_all_names))
    } else {
      col_to_select <-
        union(c("CRSHNMBR"), col_to_select)
    }
  } else {
    col_to_select <- c()
  }

  found_columns <- read_cols(file_to_read, col_to_select)
  # I'm using mutate_at and any_of to change class type only if column exists
  fst::read_fst(file_to_read, as.data.table = TRUE, columns = found_columns) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::any_of(
      c(
        "MCFLNMBR",
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
    dplyr::mutate_at(dplyr::vars(dplyr::any_of(
      c(
        "URBRURAL",
        "STPTLNB",
        "ZIPCODE",
        "NTFYDATE",
        "TKBSPRMT",
        "MCFLNMBR",
        "DOCTNMBR"
      )
    )), as.character) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::starts_with("DMGAR")), as.character) %>%
    # mutate_at(dplyr::vars(any_of("NTFYDATE")), ymd) %>%
    # Format county name so they are not all in caps
    dplyr::mutate_at("CNTYCODE", stringr::str_to_title) %>%
    dplyr::mutate(CNTYCODE = ifelse(.data$CNTYCODE == "Fond Du Lac", "Fond du Lac", .data$CNTYCODE))
  # ZIPCODE = ifelse(is.na(ZIPCODE), "0", ZIPCODE)
}


#' Get a list of all years in between two dates
#'
#' Useful when importing data among many years. Must be exactly two digits (i.e. 1992 would be "92").
#' @param start_year start year of list, lowest is 1985.
#' @param end_year end year of list, highest is 2030.
#'
#' @return list of dates for years and years_old for data import
#' @export
#'
#' @examples
#' get_list_of_years("99", "14")
get_list_of_years <- function(start_year,
                              end_year) {
  # between 1985 and 2030
  if (start_year > 85 & end_year < 30) {
    year1 = as.character(seq(start_year, 99,  1))
    year2 = formatC(
      seq(00, end_year, 1),
      digits = 0,
      width = 2,
      format = "f",
      flag = "0"
    )
    return(c(year1, year2))
    # between 1985 and 1999
  } else if (start_year > 85 & end_year <= 99) {
    return(as.character(seq(start_year, end_year,  1)))
  } # between 2000 and 2030
  else if (start_year >= 0 & end_year < 30) {
    return(formatC(seq(start_year, end_year, 1), digits = 0, width = 2, format = "f", flag = "0"))
  }
}
