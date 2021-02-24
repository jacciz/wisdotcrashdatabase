#' Bin age groups by 5 or 10 years (new db)
#'
#' This bins ages into age groups by 5 years or 10 years.
#' @inheritParams get_driver_flags
#' @param bin_by select either "5_yr" or "10_yr"
#'
#' @return A new column called \emph{age_group_5yr} or \emph{age_group_10yr}
#' @export
#'
#' @examples
#' \dontrun{get_age_groups(person17, group_by = "10_yr"}
get_age_groups <- function(person_df,
                           bin_by = "5_yr") {
  if (bin_by == "5_yr") {
    return(age_group_5yr(person_df))
  }
  if (bin_by == "10_yr") {
    return(age_group_10yr(person_df))
  }
}

age_group_5yr <- function(person_df) {
  person_df <- person_df %>% dplyr::mutate(age_group_5yr = cut(
    # add age_group column, 5 year intervals
    .data$person_df$AGE,
    right = FALSE,
    c(0, 4, 9, 14, 19, 24, 29, 34, 39, 44, 49, 54, 59, 64, 69, 120),
    labels = c(
      "0-4",
      "5-9",
      "10-14",
      "15-19",
      "20-24",
      "25-29",
      "30-34",
      "35-39",
      "40-44",
      "45-49",
      "50-54",
      "55-59",
      "60-64",
      "65-69",
      "70+"
    ),
    include.lowest = T
  ))
  # Get levels of age_group factor and add Unknown
  levels <- levels(.data$person_df$age_group_5yr)
  levels[length(levels) + 1] <- "UNKNOWN"
  # refactor agegroup to include "None" as a factor level
  # and replace NA with "None"
  person_df$age_group_5yr <-
    factor(.data$person_df$age_group_5yr, levels = levels)
  .data$person_df$age_group_5yr[is.na(.data$person_df$age_group_5yr)] <-
    "UNKNOWN"
  person_df
}
# This is to match old crash . Old db age = 0 is UNKNOWN
# Add this ?? dplyr::mutate(age_group_10yr = ifelse(age_group_10yr == "UNKNOWN", AGE_GROUP, as.character(age_group_10yr)))
age_group_10yr <- function(person_df) {
  person_df <-
    person_df %>% dplyr::mutate(age_group_10yr = cut(
      # add age_group column
      .data$person_df$AGE,
      # right = FALSE,
      c(
        1,
        2,
        3,
        4,
        9,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24,
        34,
        44,
        54,
        64,
        74,
        84,
        120
      ),
      labels = c(
        "1-2",
        "3",
        "4",
        "5-9",
        "10-14",
        "15",
        "16",
        "17",
        "18",
        "19",
        "20",
        "21",
        "22",
        "23",
        "24",
        "25-34",
        "35-44",
        "45-54",
        "55-64",
        "65-74",
        "75-84",
        "85 AND OVER"
      ),
      include.lowest = T
    ))
  # Get levels of age_group factor and add Unknown
  levels <- levels(.data$person_df$age_group_10yr)
  levels[length(levels) + 1] <- "UNKNOWN"
  # refactor agegroup to include "None" as a factor level
  # and replace NA with "None"
  person_df$age_group_10yr <-
    factor(.data$person_df$age_group_10yr, levels = levels)
  .data$person_df$age_group_10yr[is.na(.data$person_df$age_group_10yr)] <-
    "UNKNOWN"
  person_df
}
