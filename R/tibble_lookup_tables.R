
lookup_susp_drug <- tibble::tribble(
  ~DRUGSUSP, ~drug_flag,
  "101", "Y",
  "Yes", "Y",
  "Y",   "Y",
  "102", "N",
  "No",  "N",
  "N",   "N",
  "Unknown", "U",
  "999", "U",
  "",    "U",
  NA,    "U"
)

lookup_susp_alcohol <- tibble::tribble(
  ~ALCSUSP, ~alcohol_flag,
  "101", "Y",
  "Yes", "Y",
  "Y",   "Y",
  "102", "N",
  "No",  "N",
  "N",   "N",
  "Unknown", "U",
  "999", "U",
  "",    "U",
  NA,    "U"
)

lookup_role_bike_ped <- tibble::tribble(
  ~ROLE, ~bike_ped_role,
  "Bicyclist", "Bicyclist",
  "BICYCLIST", "Bicyclist",
  "Other Cyclist", "Bicyclist",
  "PEDESTRIAN", "Pedestrian",
  "Pedestrian","Pedestrian",
  "Other Pedestrian", "Pedestrian",
  "Pedestrian (Non-Occupant)", "Pedestrian"
)

bin_wisinj_levels <- tibble::tribble(
  ~WISINJ,  ~ inj,
  "Fatal Injury",  "Killed",
  "Suspected Serious Injury",  "Injured",
  "Suspected Minor Injury",  "Injured",
  "Possible Injury",  "Injured",
  "No Apparent Injury",  "No Injury"
)

lookup_countycode <- tibble::tribble(
  ~ctycode, ~countyname,
  "01", "Adams",
  "02", "Ashland",
  "03", "Barron",
  "04", "Bayfield",
  "05", "Brown",
  "06", "Buffalo",
  "07", "Burnett",
  "08", "Calumet",
  "09", "Chippewa",
  "0", "Unknown",
  "1", "Adams",
  "2", "Ashland",
  "3", "Barron",
  "4", "Bayfield",
  "5", "Brown",
  "6", "Buffalo",
  "7", "Burnett",
  "8", "Calumet",
  "9", "Chippewa",
  "10", "Clark",
  "11", "Columbia",
  "12", "Crawford",
  "13", "Dane",
  "14", "Dodge",
  "15", "Door",
  "16", "Douglas",
  "17", "Dunn",
  "18", "Eau Claire",
  "19", "Florence",
  "20", "Fond du Lac",
  "21", "Forest",
  "22", "Grant",
  "23", "Green",
  "24", "Green Lake",
  "25", "Iowa",
  "26", "Iron",
  "27", "Jackson",
  "28", "Jefferson",
  "29", "Juneau",
  "30", "Kenosha",
  "31", "Kewaunee",
  "32", "La Crosse",
  "33", "Lafayette",
  "34", "Langlade",
  "35", "Lincoln",
  "36", "Manitowoc",
  "37", "Marathon",
  "38", "Marinette",
  "39", "Marquette",
  "73", "Menominee",
  "40", "Milwaukee",
  "41", "Monroe",
  "42", "Oconto",
  "43", "Oneida",
  "44", "Outagamie",
  "45", "Ozaukee",
  "46", "Pepin",
  "47", "Pierce",
  "48", "Polk",
  "49", "Portage",
  "50", "Price",
  "51", "Racine",
  "52", "Richland",
  "53", "Rock",
  "54", "Rusk",
  "55", "St. Croix",
  "56", "Sauk",
  "57", "Sawyer",
  "58", "Shawano",
  "59", "Sheboygan",
  "60", "Taylor",
  "61", "Trempealeau",
  "62", "Vernon",
  "63", "Vilas",
  "64", "Walworth",
  "65", "Washburn",
  "66", "Washington",
  "67", "Waukesha",
  "68", "Waupaca",
  "69", "Waushara",
  "70", "Winnebago",
  "71", "Wood",
  "72", "Out of State"
)

lookup_countycode_and_fips <- tibble::tribble(
  ~countyname, ~ctycode, ~fips,
  "Unknown","0", NA,
  "Adams","1", "001",
  "Ashland","2", "003",
  "Barron", "3", "005",
  "Bayfield","4", "007",
  "Brown", "5", "009",
  "Buffalo","6", "011",
  "Burnett","7", "013",
  "Calumet","8", "015",
  "Chippewa","9", "017",
  "Clark","10", "019",
  "Columbia","11", "021",
  "Crawford","12", "023",
  "Dane","13", "025",
  "Dodge","14", "027",
  "Door","15", "029",
  "Douglas","16", "031",
  "Dunn","17", "033",
  "Eau Claire", "18", "035",
  "Florence","19", "037",
  "Fond du Lac","20", "039",
  "Forest","21", "041",
  "Grant","22", "043",
  "Green","23", "045",
  "Green Lake", "24", "047",
  "Iowa","25", "049",
  "Iron", "26", "051",
  "Jackson","27", "053",
  "Jefferson","28", "055",
  "Juneau","29", "057",
  "Kenosha","30", "059",
  "Kewaunee","31", "061",
  "La Crosse","32", "063",
  "Lafayette", "33", "065",
  "Langlade","34", "067",
  "Lincoln","35", "069",
  "Manitowoc","36", "071",
  "Marathon","37",  "073",
  "Marinette","38", "075",
  "Marquette","39", "077",
  "Menominee","73", "078",
  "Milwaukee","40", "079",
  "Monroe","41", "081",
  "Oconto","42", "083",
  "Oneida","43", "085",
  "Outagamie","44", "087",
  "Ozaukee","45", "089",
  "Pepin","46", "091",
  "Pierce","47", "093",
  "Polk","48", "095",
  "Portage","49", "097",
  "Price", "50", "099",
  "Racine","51", "101",
  "Richland", "52", "103",
  "Rock", "53", "105",
  "Rusk", "54", "107",
  "St. Croix","55", "109",
  "Sauk","56", "111",
  "Sawyer","57", "113",
  "Shawano","58", "115",
  "Sheboygan","59", "117",
  "Taylor","60", "119",
  "Trempealeau","61", "121",
  "Vernon", "62", "123",
  "Vilas","63", "125",
  "Walworth", "64", "127",
  "Washburn", "65", "129",
  "Washington","66", "131",
  "Waukesha","67", "133",
  "Waupaca","68", "135",
  "Waushara","69", "137",
  "Winnebago","70", "139",
  "Wood","71", "141",
  "Out of State","72", NA
)
old_crash_groups <- tibble::tribble(
  ~CRSHTIME_GROUP, ~newtime_old,
  "12-1  AM", "12am",
  "1-2   AM", "1am",
  "2-3   AM", "2am",
  "3-4   AM", "3am",
  "4-5   AM", "4am",
  "5-6   AM", "5am",
  "6-7   AM", "6am",
  "7-8   AM",  "7am",
  "8-9   AM", "8am",
  "9-10  AM", "9am",
  "10-11 AM", "10am",
  "11-12 NOON", "11am",
  "12-1  PM", "12pm",
  "1-2   PM", "1pm",
  "2-3   PM", "2pm",
  "3-4   PM",  "3pm",
  "4-5   PM", "4pm",
  "5-6   PM", "5pm",
  "6-7   PM", "6pm",
  "7-8   PM", "7pm",
  "8-9   PM", "8pm",
  "9-10  PM", "9pm",
  "10-11 PM", "10pm",
  "11-MIDNITE", "11pm",
  "UNKNOWN", NA,
  "12 MIDNITE", "12am",
  "12 NOON", "12pm"
)
