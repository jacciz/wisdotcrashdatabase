# This relabels so county code is exactly 2 digits, not needed
# all_crashes <-
#   all_crashes %>% dplyr::mutate(CNTYCODE = formatC(
#       CNTYCODE, digits = 0, width = 2, format = "f", flag = "0"))

# to run: county_rename(insert dataframe here), add column called countyname. CNTYCODE must be integer

#' Get county name from CNTYCODE
#'
#' CNTYCODE must be an integer.
#' @param any_df person, crash, or vehicle dataframe
#'
#' @return Same dataframe, countyname column
#' @export
#'
#' @examples
#' \dontrun{county_rename(vehicle17)}
county_rename <-
  function(any_df) {
    any_df %>% dplyr::mutate(countyname = dplyr::recode(
      any_df$CNTYCODE,
      !!!c(
        "0" = "Unknown",
        "1" = "Adams",
        "2" = "Ashland",
        "3" = "Barron",
        "4" = "Bayfield",
        "5" = "Brown",
        "6" = "Buffalo",
        "7" = "Burnett",
        "8" = "Calumet",
        "9" = "Chippewa",
        "10" = "Clark",
        "11" = "Columbia",
        "12" = "Crawford",
        "13" = "Dane",
        "14" = "Dodge",
        "15" = "Door",
        "16" = "Douglas",
        "17" = "Dunn",
        "18" = "Eau Claire",
        "19" = "Florence",
        "20" = "Fond du Lac",
        "21" = "Forest",
        "22" = "Grant",
        "23" = "Green",
        "24" = "Green Lake",
        "25" = "Iowa",
        "26" = "Iron",
        "27" = "Jackson",
        "28" = "Jefferson",
        "29" = "Juneau",
        "30" = "Kenosha",
        "31" = "Kewaunee",
        "32" = "La Crosse",
        "33" = "Lafayette",
        "34" = "Langlade",
        "35" = "Lincoln",
        "36" = "Manitowoc",
        "37" = "Marathon",
        "38" = "Marinette",
        "39" = "Marquette",
        "73" = "Menominee",
        "40" = "Milwaukee",
        "41" = "Monroe",
        "42" = "Oconto",
        "43" = "Oneida",
        "44" = "Outagamie",
        "45" = "Ozaukee",
        "46" = "Pepin",
        "47" = "Pierce",
        "48" = "Polk",
        "49" = "Portage",
        "50" = "Price",
        "51" = "Racine",
        "52" = "Richland",
        "53" = "Rock",
        "54" = "Rusk",
        "55" = "St. Croix",
        "56" = "Sauk",
        "57" = "Sawyer",
        "58" = "Shawano",
        "59" = "Sheboygan",
        "60" = "Taylor",
        "61" = "Trempealeau",
        "62" = "Vernon",
        "63" = "Vilas",
        "64" = "Walworth",
        "65" = "Washburn",
        "66" = "Washington",
        "67" = "Waukesha",
        "68" = "Waupaca",
        "69" = "Waushara",
        "70" = "Winnebago",
        "71" = "Wood",
        "72" = "Out of State"
      )
    ))
  }
