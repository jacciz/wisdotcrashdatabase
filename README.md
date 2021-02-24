
<!-- README.md is generated from README.Rmd. Please edit that file -->

# wisdotcrashdatabase

<!-- badges: start -->
<!-- badges: end -->

The goal of wisdotcrashdatabase is to make data pulls and data analysis
much easier in an R environment. To set up an R environment, you must
convert the entire database into CSVs. I wrote automated scripts for
these. Haven package is an option, but a couple things were not working
properly. This package has functions to get certain crash flags, relabel
by age or injury type for easier grouping.

## Installation

This package will never be released to CRAN as it’s used internally at
WisDOT.

The package can be installed from [GitHub](https://github.com/) with:

``` r
install.packages("devtools")
devtools::install_github("jacciz/wisdotcrashdatabase")
```

## Setting up environment

The format data in this package must be in a .fst, while narratives are
read as a .csv. In order to set the up, SAS code is run for each year
and is exported to a folder of your choosing. Run the code in
inst/extdata/SAS\_to\_FST/ to do this. Data for each year must be run.
Place all data in the same folder.

Next, run CSV\_to\_FST.R. This reads the CSV files and exports as a FST.
This is a batch job and can be run only once.

## Importing data

Old and new database data can be uploaded and imported via a single data
frame. If new db is selected, then columns will have to be selected.
Certain old db columns are renamed to match the new db. Import is done
with one function:

``` r
library(wisdotcrashdatabase)
library(lubridate)
#> 
#> Attaching package: 'lubridate'
#> The following objects are masked from 'package:base':
#> 
#>     date, intersect, setdiff, union
library(magrittr)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

import_db_data(
  filepath = "C:/CSV/csv_from_sas/fst/",
  db_type = "crash",
  years_old = c("15", "16"),
  years = c("17", "18")
) %>% count(year(CRSHDATE))
#>    year(CRSHDATE)      n
#> 1:           2015 121613
#> 2:           2016 129051
#> 3:           2017 139870
#> 4:           2018 144212
```

## Crash flags

-   Deer
-   Distracted driver
-   Impaired driver
-   Speed
-   Teen driver
-   Older driver\_flag
-   Seatbelt\_flag\_by\_unit
-   Suspected drug or alcohol

``` r
import_db_data(
  filepath = "C:/CSV/csv_from_sas/fst/",
  db_type = "person",
  years_old = c("16"),
  years = c("17", "18"),
  columns = c("STATNM", "DRVRPC")
) %>% get_driver_flags (flags = "speed") %>%
  filter(speed_flag == "Y") %>%
  distinct(CRSHNMBR, .keep_all = TRUE) %>%
  count(year = year(CRSHDATE))
#>    year     n
#> 1: 2016 19540
#> 2: 2017 19182
#> 3: 2018 20061
```

## Relabel functions

-   Bin crash times
-   Bin age groups
-   Get county names based on cntycode
-   Bin injures into Killed, Injured, No Injury

``` r
import_db_data(
  filepath = "C:/CSV/csv_from_sas/fst/",
  db_type = "person",
  years_old = c("16"),
  years = c("17", "18")
) %>% relabel_person_variables(relabel_by = "wisinj") %>% count(year = year(CRSHDATE), inj)
#> Joining, by = "WISINJ"
#>    year       inj      n
#> 1: 2016   Injured  43669
#> 2: 2016    Killed    588
#> 3: 2016 No Injury 240916
#> 4: 2017   Injured  42178
#> 5: 2017    Killed    594
#> 6: 2017 No Injury 248072
#> 7: 2018   Injured  41124
#> 8: 2018    Killed    576
#> 9: 2018 No Injury 255579
```
