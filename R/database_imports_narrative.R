#' Import crash narratives
#'
#' Import crash narratives.
#' @inheritParams import_db_data
#'
#' @return dataframe of crash narratives
#' @export
#'
#' @examples
#' import_narrative(filepath = "C:/CSV/csv_from_sas/from_sas_csv/", years = c("17","18"))
import_narrative <-
  function(filepath,
           years) {
    data_years = paste(years, "narrative", sep = "") # combines crashes with years to select data
    narrative = paste(filepath, data_years, ".csv", sep = "") # select data in specified location/format
    combine_data <-  #columns = c("RECDSTAT")
      do.call(dplyr::bind_rows, lapply(narrative, utils::read.csv)) # reads and combines data
  }
