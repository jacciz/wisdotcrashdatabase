# usethis::use_r("animal_sounds")
# devtools::load_all()


# Read the first row to find which columns actually exists, returns columns that exist
read_cols <- function(file_name, colsToKeep) {
  header <- fst::read_fst(file_name, to = 1)
  subset(colsToKeep, colsToKeep %in% colnames(header))
}


# This reads fst files and converts data types so they all match for all db
# I'm using mutate_at and any_of to change class type only if column exists
read_fst_for_new_db <- function(file_to_read, col_to_select) {
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
    mutate_at(dplyr::vars(dplyr::starts_with("HAZCLSS")), as.character)
  # mutate_at(dplyr::vars(any_of("NTFYDATE")), ymd)
}
