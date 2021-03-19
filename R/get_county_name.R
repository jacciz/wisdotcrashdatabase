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


#' Find county code and fips
#'
#' @param county_to_find full name of county(ies)#'
#'
#' @return tibble with county code and fips
#' @export
#'
#' @examples
#' find_countycode_fips("Dane")
find_countycode_fips <- function(county_to_find){
  lookup_countycode_and_fips %>% filter(.data$countyname == county_to_find)
}


#' Find municode by municipality
#'
#' @param municipality_to_find name of municipality (i.e. "Adams")
#' @param ctv c("City", "Town", "Village")
#'
#' @return df with municode and county code
#' @export
#'
#' @examples
#' data(muni)
#' find_municipality_codes("Adams", "Town")
find_municipality_codes <- function(municipality_to_find, ctv){
  # data("muni", envir=environment()) importFrom utils data
  get("muni")
  muni %>% filter(.data$Municipality %in% municipality_to_find, .data$MuniTownype %in% ctv)
}
