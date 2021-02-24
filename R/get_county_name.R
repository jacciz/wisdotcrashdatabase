#' Get full county name
#'
#' This looks at the county code and returns a new column \emph{countyname} of the full
#' county name.
#' @importFrom stats setNames
#' @param any_df person, crash, or vehicle dataframe
#' @param county_col column that has the county code
#'
#' @return A new column called \emph{countyname}
#' @export
#'
#' @examples
#' \dontrun{county_rename(vehicle17)}
county_rename <-
  function(any_df,
           county_col = "CNTYCODE") {
    if (county_col == "CNTYCODE") {
      any_df <-
        any_df %>% dplyr::mutate(CNTYCODE = as.character(.data$CNTYCODE))
    }
    dplyr::left_join(any_df, lookup_countycode, by = setNames(nm = county_col, "ctycode")) # WORKS
  }
