
lookup_susp_drug <- tibble::tribble(
  ~DRUGSUSP, ~drug_flag,
  "101", "Y",
  "Yes", "Y",
  "102", "N",
  "No", "N",
  "999","U",
  "", "U",
  NA, "U"
)

lookup_susp_alcohol <- tibble::tribble(
  ~ALCSUSP, ~alcohol_flag,
  "101", "Y",
  "Yes", "Y",
  "102", "N",
  "No", "N",
  "999","U",
  "", "U",
  NA, "U"
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

bin_wis_injury_levels <- tibble::tribble(
  !WISINJ, ~inj,
"Fatal Injury", "Killed",
"Suspected Serious Injury", "Injured",
"Suspected Minor Injury", "Injured",
"Possible Injury", "Injured",
"No Apparent Injury", "No Injury"
)
