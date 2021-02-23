###### Function to Relabel Variables in Old Db ######
# These are used when reading FST files
relabel_CRSHSVR_old_db <- function(df) {
  df %>%
    dplyr::mutate(CRSHSVR = dplyr::recode(
      .data$CRSHSVR,
      !!!c(
        "PROPERTY DAMAGE" = "Property Damage",
        "INJURY" = "Injury",
        "FATAL" = "Fatal")
    ))
}

relabel_WISINJ_old_db <- function(df) {
  df %>%
    dplyr::mutate(WISINJ = dplyr::recode(
      expss::na_if(.data$WISINJ, ""),
      !!!c(
        "INCAPACITATING" = "Suspected Serious Injury",
        "NONINCAPACITATING" = "Suspected Minor Injury",
        "POSSIBLE" = "Possible Injury",
        "KILLED" = "Fatal Injury",
        .missing = "No Apparent Injury"
      )
    ))
}
