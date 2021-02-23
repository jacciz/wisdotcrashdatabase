#' Get distracted driver flag
#'
#' This returns a column distracted == Y.

#' @param person_df data frame of person, must have ROLE, UNITNMBR, DISTACT,
#'   DRVRDS
#'
#' @return speed_flag (Y or N)
#' @export
#'
#' @examples
get_distracted_driver_flag <- function(person_df) {
  distracted <- person_df %>%
    dplyr::select(.data$ROLE,
                  .data$CRSHNMBR,
                  .data$UNITNMBR,
                  dplyr::any_of(dplyr::starts_with(c(
                    "DISTACT", "DRVRDS"
                  )))) %>%
    dplyr::filter(.data$ROLE == 'Driver') %>%
    dplyr::filter_all(dplyr::any_vars(
      grepl(
        "Talking|Manually Operating|Other Action|Manually Operating|Electronic Device|Passenger|Eating|Outside|Vehicle|Looked|Moving Object|Adjusting Audio|Outside Person|Smoking|Other Cellular|Inattention|Careless|Details Unknown$|Daydreaming|Other Distraction|Distraction/Inattention",
        .
      )
    ))
  # Find where 'Not distracted' is listed even though a distraction may have been listed
  not_distracted <- person_df %>%
    dplyr::select(
      .data$ROLE,
      .data$UNITNMBR,
      .data$CRSHNMBR,
      .data$CRSHDATE,
      dplyr::any_of(dplyr::starts_with(c(
        "DISTACT", "DRVRDS"
      )))
    ) %>%
    dplyr::filter(.data$ROLE == 'Driver') %>% dplyr::filter_all(dplyr::any_vars(!grepl(
      "Not Distracted|Unknown If Distracted", .
    ) == FALSE))
  combine <-
    # Remove all 'Not distracted' and add a column of distracted_flag
    dplyr::anti_join(distracted, not_distracted, by = c("CRSHNMBR", "UNITNMBR")) %>% dplyr::select(.data$CRSHNMBR, .data$UNITNMBR, .data$ROLE) %>% dplyr::mutate(distracted_flag = "Y")
  return(
    dplyr::left_join(person_df, combine, by = c("CRSHNMBR", "UNITNMBR", "ROLE")) %>% dplyr::mutate(distracted_flag = tidyr::replace_na(.data$distracted_flag, "N"))
  )
}

get_speed_flag <- function(person_df) {
  speed <- person_df %>%
    dplyr::select(
      .data$ROLE,
      .data$DRVRFLAG,
      .data$UNITNMBR,
      .data$CRSHNMBR,
      dplyr::starts_with("DRVRPC"),
      dplyr::starts_with("STATNM")
    ) %>%
    dplyr::filter(.data$ROLE == 'Driver' |
                    .data$DRVRFLAG == 'Y') %>% dplyr::filter_all(dplyr::any_vars(
                      grepl(
                        # To account for new and old databases, use upper and lower case
                        "^346.55|^346.56|^346.57|^346.58|^346.59(1)|^346.59(2)|Exceed Speed Limit|Speed Too Fast/Cond|^346.55 5|^346.59 1|^346.59 2|SPEEDING IN EXCESS OF FIXED LIMITS|SPEED TOO FAST/COND|EXCEED SPEED LIMIT|DRIVING TOO FAST|EXCEEDING ZONES AND POSTED LIMITS|ANY VIOLATION OF SPEED RESTRICTIONS|UNREASONABLE AND IMPRUDENT SPEED",
                        .
                      )
                    )) %>% dplyr::select(.data$CRSHNMBR, .data$UNITNMBR, .data$ROLE) %>% dplyr::mutate(speed_flag = "Y")
  return(
    dplyr::left_join(person_df, speed, by = c("CRSHNMBR", "UNITNMBR", "ROLE")) %>% dplyr::mutate(speed_flag = tidyr::replace_na(.data$speed_flag, "N"))
  )
}

#' Get alcohol or drug person, or by driver
#'
#' @importFrom magrittr %>%
#' @param person_df person df (new or old)
#' @param driver_only role as driver?
#' @param include_alc suspected alcohol?
#' @param include_drug suspected drug?
#' @param by intersection by - either "and" or "or"
#'
#' @return same person_df with drug_flag or alcohol_flag
#' @export
#'
#' @examples
get_alc_drug_impaired_person <- function(person_df,
                                         driver_only = "N",
                                         include_alc = "Y",
                                         include_drug = "Y",
                                         by = "and") {
  if (driver_only == "Y") {
    person_df <-
      person_df %>% dplyr::filter(.data$ROLE %in% c("DRIVER", "Driver") |
                                    .data$DRVRFLAG == 'Y')
  }
  if (include_alc == "Y") {
    person_df <- person_df %>%
      dplyr::left_join(lookup_susp_alcohol) %>%
      dplyr::mutate(alcohol_flag = ifelse(is.na(.data$alcohol_flag), "U", .data$alcohol_flag))
  }
  if (include_drug == "Y") {
    person_df <- person_df %>%
      dplyr::left_join(lookup_susp_drug) %>%
      dplyr::mutate(drug_flag = ifelse(is.na(.data$drug_flag), "U", .data$drug_flag))
  }
  return(person_df)
  # return(dplyr::left_join(alc_df, drug_df, by = c("CRSHNMBR", "CUSTNMBR")))
}

# get_teen_driver <- function(person_df) {
#   teen <-
#     person_df %>% dplyr::filter(AGE %in% c(16, 17, 18, 19), ROLE == 'Driver' |
#                                   DRVRFLAG == 'Y') %>% dplyr::select(CRSHNMBR, UNITNMBR, ROLE) %>% dplyr::mutate(teendriver_flag = "Y")
#   teen[is.na(teen)] <- "N"
#   return(dplyr::left_join(person_df, teen, by = c("CRSHNMBR", "UNITNMBR", "ROLE"))%>% dplyr::mutate(teendriver_flag = tidyr::replace_na(teendriver_flag, "N")))
# }
#
# get_older_driver <- function(person_df) {
#   older <-
#     person_df %>% filter(AGE >= 65, ROLE == 'Driver' |
#                            DRVRFLAG == 'Y') %>% dplyr::select(CRSHNMBR, UNITNMBR, ROLE) %>% dplyr::mutate(olderdriver_flag = "Y")
#   return(dplyr::left_join(person_df, older, by = c("CRSHNMBR", "UNITNMBR", "ROLE")) %>% dplyr::mutate(olderdriver_flag = tidyr::replace_na(olderdriver_flag, "N")))
# }
#
# # get_seat_belt <- # may need character, not attribute code
# #   function(person_df) {
# #     person_df %>% filter(SFTYEQP == 105 |
# #                            (-(EYEPROT %in% c(101, 102, 103)) & HLMTUSE == 104))
# #   }
# get_seatbelt_flag_by_role <- function(person_df) {
#   sb <-
#     person_df %>% dplyr::filter((
#       SFTYEQP %in% c("None Used - Vehicle Occupant",
#                      "NONE USED-VEHICLE OCCUPANT") |
#         (-(
#           EYEPROT %in% c("Yes: Worn", "Yes: Windshield", "Yes: Worn and Windshield")
#         ) & HLMTUSE %in% c("No"))
#     )) %>% dplyr::select(CRSHNMBR, UNITNMBR, ROLE) %>% dplyr::mutate(seatbelt_flag_role = "Y")
#   return(dplyr::left_join(person_df, sb, by = c("CRSHNMBR", "UNITNMBR", "ROLE")) %>% dplyr::mutate(seatbelt_flag_role = tidyr::replace_na(seatbelt_flag_role, "N")))
# }
#
# get_seatbelt_flag_by_unit <- function(person_df) {
#   sb <-
#     person_df %>% filter((
#       SFTYEQP %in% c("None Used - Vehicle Occupant",
#                      "NONE USED-VEHICLE OCCUPANT") |
#         (-(
#           EYEPROT %in% c("Yes: Worn", "Yes: Windshield", "Yes: Worn and Windshield")
#         ) & HLMTUSE %in% c("No"))
#     )) %>% dplyr::select(CRSHNMBR, UNITNMBR) %>% dplyr::mutate(seatbelt_flag_unit = "Y")
#   return(dplyr::left_join(person_df, sb, by = c("CRSHNMBR", "UNITNMBR")) %>% dplyr::mutate(seatbelt_flag_unit = tidyr::replace_na(seatbelt_flag_unit, "N")))
# }
