#' Get motorcyclists
#'
#' Need VEHTYPE and UNITNMBR.
#' @param person_df person dataframe
#' @param vehicle_df vehicle dataframe
#'
#' @return all motorcyclists
#' @export
#'
#' @examples
#' \dontrun{get_motorcycle_persons(person17, vehicle17)}
get_motorcycle_persons <- function(person_df, vehicle_df) {
  motorcycle <-
    vehicle_df %>% dplyr::filter(.data$VEHTYPE == "Motorcycle" |
                                   .data$VEHTYPE == "MOTORCYCLE") %>% dplyr::select(.data$CRSHNMBR, .data$UNITNMBR)
  return(dplyr::semi_join(
    person_df,
    motorcycle,
    by = c("CRSHNMBR" = "CRSHNMBR", "UNITNMBR" = "UNITNMBR")
  )) # use semi_join to keep all obsv in x that match in y
}
