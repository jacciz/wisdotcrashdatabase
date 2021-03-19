
<!-- README.md is generated from README.Rmd. Please edit that file -->

# wisdotcrashdatabase

<!-- badges: start -->
<!-- badges: end -->

wisdotcrashdatabase makes data pulls and data analysis much easier
inside an R environment. To set up an R environment, you must convert
the entire database into FST format. I wrote automated scripts for
these. Haven package is an option, but formatting of the labels was an
issue. This package can gather crash flags, relabel by age or injury
type for easier grouping, and can lookup county/municiaplity codes.

## Installation

This package will never be released to CRAN as it’s used internally at
WisDOT.

The package can be installed from [GitHub](https://github.com/) with:

``` r
install.packages("devtools")
devtools::install_github("jacciz/wisdotcrashdatabase")
```

## Setting up the environment

The format data in this package must be in a .fst, but narratives must
be in a .csv. In order to set the up, SAS code is run for each year and
is exported to a folder of your choosing. This is done by running the
three SAS scripts in inst/extdata/SAS\_to\_FST/. Use the appropriate
code for the appropriate crash db year. This code outputs a CSV of
crash, person, vehicle, and narrative. Scripts must be run for each
year. These CSVs must be in a single folder and you may have to change
the folder path in the code.

Next, run the R code to translate the .csv to .fst with
‘CSV\_to\_FST.R’. This reads all the CSV files and exports each as a
FST. This is a batch job and can run only ONCE. To update current year
(like 2021), the .ps1 file automates this translation from SAS to .fst
by running the command in Shell. Be sure to change the file paths!

## Importing data

Old and new database data can be imported into R as a single data frame.
If ‘years’ for a new db is selected, then columns will have to be
selected. Certain old db columns are renamed to match the new db. Some
columns will always be selected (see Documentation). Import is done with
one function:

#### Example: Number of crashes

``` r
library(wisdotcrashdatabase)
library(lubridate)
library(magrittr)
library(dplyr)

crash <- import_db_data(
  filepath = "C:/CSV/csv_from_sas/fst/",
  db_type = "crash",
  years_old = c("15", "16"),
  years = c("17", "18"),
  columns = c("CRSHMTH")
)
crash %>% count(year(CRSHDATE))
#>    year(CRSHDATE)      n
#> 1:           2015 121613
#> 2:           2016 129051
#> 3:           2017 139870
#> 4:           2018 144212
```

## Crash flags functions

There are also functions to get crash flags. When run, a new column is
added with either a “Y” or “N” if that flag exists. Flags include:

-   Deer
-   Distracted driver
-   Impaired driver
-   Speed
-   Teen driver
-   Older driver\_flag
-   Seatbelt\_flag\_by\_unit
-   Suspected drug or alcohol

#### Example: Number of speed crashes

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

There’s also functions that may summarize data for analysis. These
include:

-   Bin crash times
-   Bin age groups
-   Get county names based on cntycode
-   Bin injures into Killed, Injured, No Injury

#### Example: People injured

``` r
import_db_data(
  filepath = "C:/CSV/csv_from_sas/fst/",
  db_type = "person",
  years_old = c("16"),
  years = c("17", "18")
) %>% relabel_person_variables(relabel_by = "wisinj") %>%
  count(year = year(CRSHDATE), inj)
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

## Other functions

-   Get motorcyclists
-   Import crash narratives
-   Lookup county code and fips \# Lookup municode by name and ctv

## For help

Load the wisdotcrashdatabase package in R and type in the console
`?import_db_data` or any other function.
