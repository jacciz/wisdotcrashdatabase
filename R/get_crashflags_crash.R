#' Get flag for deer crashes (old and new db)
#'
#' This finds if a crash involved a deer. Need \strong{CRSHTYPE} and \strong{ANMLTY}.
#' @param crash_df crash dataframe
#'
#' @return A new column called \emph{deer_flag} ("Y" or "N")
#' @export
#' @examples
#' \dontrun{get_deerflag_crashes(crash17)}
get_deerflag_crashes <- function(crash_df) {
  deer <- crash_df %>% #filter deer crashes
    dplyr::select(dplyr::any_of(dplyr::starts_with(c("CRSHTYPE","ANMLTY"))), .data$CRSHNMBR) %>%
    dplyr::filter(((
      .data$CRSHTYPE == "Non Domesticated Animal (Alive)" |
        .data$CRSHTYPE == "Non Domesticated Animal (Dead)"
    ) & apply(., 1, function(thisrow)
      any(thisrow %in% "Deer"))
    ) | .data$CRSHTYPE == "DEER") %>% dplyr::select(.data$CRSHNMBR) %>% dplyr::mutate(deer_flag = "Y")
  return(dplyr::left_join(crash_df, deer, by = "CRSHNMBR") %>%
           dplyr::mutate(deer_flag = tidyr::replace_na(.data$deer_flag, "N")))
}

#' Get location of crash
#'
#' @param crash_df crash dataframe w/ c("RLTNTRWY", "CRSHLOC", "INTTYPE", "INTDIS")
#'
#' Find if crash is intersection, non-intersection, parking lot, or private property.
#' @return A new column called \emph{crash_location}. This is for old and new bd, but
#' note that old db doesn't include parking lot/private property crashes.
#' @export
#'
#' @examples
#' \dontrun{get_crash_location(crash17)}
get_crash_location <- function(crash_df) {
  dplyr::mutate(
    crash_df,
    crash_location = dplyr::case_when(
      .data$RLTNTRWY == "Non Trafficway - Parking Lot" ~ "parking lot",
      .data$CRSHLOC %in% c("Private Property", "Tribal Land") ~ "private property",
      .data$INTTYPE == "Not At Intersection" ~ "non-intersection",
      .data$INTTYPE != "" ~ "intersection",
      .data$INTDIS > 0 ~ "non-intersection",
      TRUE ~ "intersection"
    )
  )
}
