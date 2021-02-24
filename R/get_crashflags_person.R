#' Get driver flags - speed, distracted, teen, older
#'
#' This adds a column(s) of certain crash flags. Driver flags are: distracted,
#' speed, teen, and older. Speed can be for both old and new db. Rest are for
#' new db only. Must have \strong{DRVRPC} and \strong{STATNM} for speed.
#' \strong{DISTACT} and \strong{DRVRDS} for distracted. \strong{AGE} for teen
#' and older.
#' @param person_df person dataframe
#' @param flags select either/all ("distracted","speed","teen","older")
#'
#' @return Returns only drivers. Adds a column of selected flag(s) with
#'   \emph{speed_flag}, \emph{distracted_flag}, \emph{teendriver_flag}, and
#'   \emph{olderdriver_flag}. ("Y" or "N")
#' @export
#'
#' @examples
#' \dontrun{get_driver_flags(person_df, flags = c("teen", "distracted"))}
#'
get_driver_flags <- function(person_df,
                              flags) {

  person_df <- person_df %>% dplyr::filter(.data$ROLE %in% c("DRIVER", "Driver") |
                                .data$DRVRFLAG == 'Y')
  if ("distracted" %in% flags) {
    person_df <- get_distracted_driver_flag(person_df)
  }
  if ("speed" %in% flags) {
    person_df <- get_speed_flag(person_df)
  }
  if ("teen" %in% flags) {
    person_df <- get_teen_driver(person_df)
  }
  if ("older" %in% flags) {
    person_df <- get_older_driver(person_df)
  }
  person_df
}

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


get_teen_driver <- function(person_df) {
  teen <-
    person_df %>% dplyr::filter(.data$AGE %in% c(16, 17, 18, 19), .data$ROLE == 'Driver' |
                                  .data$DRVRFLAG == 'Y') %>% dplyr::select(.data$CRSHNMBR, .data$UNITNMBR, .data$ROLE) %>% dplyr::mutate(teendriver_flag = "Y")
  teen[is.na(teen)] <- "N"
  return(
    dplyr::left_join(person_df, teen, by = c("CRSHNMBR", "UNITNMBR", "ROLE")) %>% dplyr::mutate(teendriver_flag = tidyr::replace_na(.data$teendriver_flag, "N"))
  )
}

get_older_driver <- function(person_df) {
  older <-
    person_df %>% dplyr::filter(.data$AGE >= 65, .data$ROLE == 'Driver' |
                                  .data$DRVRFLAG == 'Y') %>% dplyr::select(.data$CRSHNMBR, .data$UNITNMBR, .data$ROLE) %>% dplyr::mutate(olderdriver_flag = "Y")
  return(
    dplyr::left_join(person_df, older, by = c("CRSHNMBR", "UNITNMBR", "ROLE")) %>% dplyr::mutate(olderdriver_flag = tidyr::replace_na(.data$olderdriver_flag, "N"))
  )
}

#' Get flag for a suspected alcohol or drug person (old and new db)
#'
#' This looks to see if a person was suspected of alcohol or drug use.
#' @importFrom magrittr %>%
#' @inheritParams get_driver_flags
#' @param driver_only Select for role as driver only ("Y" or"N")
#' @param include_alc Select to include suspected alcohol ("Y" or"N")
#' @param include_drug Select to include suspected drug ("Y" or"N")
#'
#' @return A new column called \emph{drug_flag} or \emph{alcohol_flag}. Values
#'   are "Y","N", and "U" for unknowm. If \emph{driver_only} = "Y", then only
#'   drivers will return.
#' @export
#'
#' @examples
#' \dontrun{get_alc_drug_impaired_person(person17, include_alc = "N")}
get_alc_drug_impaired_person <- function(person_df,
                                         driver_only = "N",
                                         include_alc = "Y",
                                         include_drug = "Y") {
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

#' Get seatbelt flag (new db)
#'
#' Finds if a person in a unit was not wearing a seatbelt. For example, a
#' passenger not wearing a seatbelt, every person in that unit would get a seat
#' belt flag. This includes the drivers and other passengers, if any. Need
#' \strong{SFTYEQP}, \strong{EYEPROT} and \strong{HLMTUSE}.
#' @importFrom magrittr %>%
#' @importFrom dplyr select mutate left_join filter
#' @inheritParams get_driver_flags
#'
#' @return A new column \emph{seatbelt_flag_unit} ("Y" or "N")
#' @export
#'
#' @examples
#' \dontrun{get_seatbelt_flag_by_unit(person17)}
get_seatbelt_flag_by_unit <- function(person_df) {
  sb <-
    person_df %>% filter((
      .data$SFTYEQP %in% c("None Used - Vehicle Occupant",
                     "NONE USED-VEHICLE OCCUPANT") |
        (-(
          .data$EYEPROT %in% c("Yes: Worn", "Yes: Windshield", "Yes: Worn and Windshield")
        ) & .data$HLMTUSE %in% c("No"))
    )) %>% select(.data$CRSHNMBR, .data$UNITNMBR) %>% mutate(seatbelt_flag_unit = "Y")
  return(left_join(person_df, sb, by = c("CRSHNMBR", "UNITNMBR")) %>% mutate(seatbelt_flag_unit = tidyr::replace_na(.data$seatbelt_flag_unit, "N")))
}

#' Relabels WISINJ and ROLE in person
#'
#' This bins certain variables by recategorizing and making a new column. This
#' is useful when working with data from an old and new database or when wanting
#' to have fewer categories. "wisinj" bins \emph{WISINJ} into "No Injury",
#' "Injured", and "Killed". "bikeped" bins \emph{ROLE} of bicyclists and
#' pedestrians.
#' @importFrom magrittr %>%
#' @inheritParams get_driver_flags
#' @param relabel_by either by "wisinj" or "bikeped"
#'
#' @return A new column of either/all \emph{inj} or \emph{bike_ped_role}
#' @export
#'
#' @examples
#' \dontrun{system.file("extdata", "17person.fst", package = "fst") %>%
#'   relabel_person_date(relabel_by = "bikeped")}
relabel_person_variables <- function(person_df,
                                relabel_by = "wisinj"){
  if (relabel_by %in% "wisinj"){
    person_df <- person_df %>% dplyr::left_join(bin_wisinj_levels)
  }
  if (relabel_by %in% "bikeped"){
    person_df <- person_df %>% dplyr::left_join(lookup_role_bike_ped)
  }
  person_df
}
