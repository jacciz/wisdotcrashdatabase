# usethis::use_r("animal_sounds")
# document() # for after insert Roxygen skeleton, updates NAMESPACE
# devtools::load_all()
# devtools::check()
# usethis::use_github()
# install() to install into library
# use_test("read_cols") to test functions (use Build pane)
# use_package("forcats") # add packages to 'Imports'
# build_readme() # Render readme.md

#  git push --set-upstream wisdotcrashdatabase master
#' Select columns to import
#'
#' Read the first row to find which columns actually exists, returns columns that exist
#' @param file_name filename
#' @param colsToKeep keep
#'
#' @return df
#' @export
#'
#' @examples
#' col_to_select = c("CRSHSVR)
read_cols <- function(file_name, colsToKeep) {
  header <- fst::read_fst(file_name, to = 1)
  # Keeps only columns found in the df
  subset(colsToKeep, colsToKeep %in% colnames(header))
}

#' Title
#'
#'This reads fst files and converts data types so they all match for all db

#' @importFrom magrittr %>%
#' @param file_to_read filename
#' @param col_to_select columns to select
#'
#' @return df
#' @export
#'
#' @examples
read_fst_for_new_db <- function(file_to_read, col_to_select) {
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
