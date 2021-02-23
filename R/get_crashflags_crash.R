#' Get deer flag for deer crashes
#'
#' Need CRSHTYPE and ANMLTY.
#' @param crash_df crash dataframe
#'
#' @return crash dataframe with deer_flag column ("Y" or "N")
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
