#' Get crash hour (new db)
#'
#' Adds a new column that gives crash hour.
#' @param dataframe dataframe
#' @param time_column Time column
#' @param combine_with_old combines newtime with old db
#'
#' @return A new column called \emph{newtime} with crash hour. i.e. "12am"
#' @export
#'
#' @examples
#' \dontrun{get_crash_times(crash17)}
get_crash_times <- function(dataframe, time_column = "CRSHTIME", combine_with_old = FALSE) {
  dataframe_time <-
  dataframe %>% dplyr::mutate(newtime = cut(
    # this finds crash time by hour
    .data[[time_column]],
    c(
      1,
      100,
      200,
      300,
      400,
      500,
      600,
      700,
      800,
      900,
      1000,
      1100,
      1200,
      1300,
      1400,
      1500,
      1600,
      1700,
      1800,
      1900,
      2000,
      2100,
      2200,
      2300,
      2400
    ),
    labels = c(
      "12am",
      "1am",
      "2am",
      "3am",
      "4am",
      "5am",
      "6am",
      "7am",
      "8am",
      "9am",
      "10am",
      "11am",
      "12pm",
      "1pm",
      "2pm",
      "3pm",
      "4pm",
      "5pm",
      "6pm",
      "7pm",
      "8pm",
      "9pm",
      "10pm",
      "11pm"
    ),
    include.lowest = T
  ))
  if (combine_with_old == TRUE){
    both = dplyr::left_join(dataframe_time, old_crash_groups, by = "CRSHTIME_GROUP") %>%
      mutate(newtime_old = as.factor(.data$newtime_old))
    return(dplyr::mutate(both, newtime_both = ifelse(is.na(.data$newtime), as.character(.data$newtime_old), as.character(.data$newtime)),
           newtime_both = as.factor(.data$newtime_both)))
  }
  return(dataframe_time)
}
