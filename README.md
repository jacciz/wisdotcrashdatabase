
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
# install.packages("devtools")
devtools::install_github("jacciz/wisdotcrashdatabase")
```

## Importing data

Old and new database data can be uploaded and imported via a single data
frame. If new db is selected, then columns will have to be selected.
Certain old db columns are renamed to match the new db. Import is done
with one function:

    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    #>     CRSHNMBR   CRSHDATE         CRSHSVR CRSHTIME_GROUP MUNICODE CNTYCODE
    #> 1: 170700471 2017-07-03          Injury           <NA>     <NA>     <NA>
    #> 2: 170311367 2017-03-07 Property Damage           <NA>     <NA>     <NA>
    #> 3: 170808687 2017-08-26 Property Damage           <NA>     <NA>     <NA>
    #> 4: 170602026 2017-06-06 Property Damage           <NA>     <NA>     <NA>
    #> 5: 171207544 2017-12-19 Property Damage           <NA>     <NA>     <NA>
    #> 6: 171106421 2017-11-15 Property Damage           <NA>     <NA>     <NA>
    #>    MUNITYPE POPCLASS CRSHMTH DAYNMBR TOTINJ TOTFATL TOTVEH TOTUNIT CRSHTYPE
    #> 1:     <NA>     <NA>    <NA>    <NA>     NA      NA     NA      NA     <NA>
    #> 2:     <NA>     <NA>    <NA>    <NA>     NA      NA     NA      NA     <NA>
    #> 3:     <NA>     <NA>    <NA>    <NA>     NA      NA     NA      NA     <NA>
    #> 4:     <NA>     <NA>    <NA>    <NA>     NA      NA     NA      NA     <NA>
    #> 5:     <NA>     <NA>    <NA>    <NA>     NA      NA     NA      NA     <NA>
    #> 6:     <NA>     <NA>    <NA>    <NA>     NA      NA     NA      NA     <NA>
    #>    LGTCOND WTHRCOND ROADCOND MNRCOLL HWYCLASS URBRURAL ONHWY ONHWYDIR ONHWYTYP
    #> 1:    <NA>     <NA>     <NA>    <NA>     <NA>     <NA>  <NA>     <NA>     <NA>
    #> 2:    <NA>     <NA>     <NA>    <NA>     <NA>     <NA>  <NA>     <NA>     <NA>
    #> 3:    <NA>     <NA>     <NA>    <NA>     <NA>     <NA>  <NA>     <NA>     <NA>
    #> 4:    <NA>     <NA>     <NA>    <NA>     <NA>     <NA>  <NA>     <NA>     <NA>
    #> 5:    <NA>     <NA>     <NA>    <NA>     <NA>     <NA>  <NA>     <NA>     <NA>
    #> 6:    <NA>     <NA>     <NA>    <NA>     <NA>     <NA>  <NA>     <NA>     <NA>
    #>    ONSTR RPNMBR RPDIS ATSTR ATHWY ATHWYDIR ATHWYTYP ATNMBR ATCODE INTDIR INTDIS
    #> 1:  <NA>     NA    NA  <NA>  <NA>     <NA>     <NA>   <NA>   <NA>   <NA>     NA
    #> 2:  <NA>     NA    NA  <NA>  <NA>     <NA>     <NA>   <NA>   <NA>   <NA>     NA
    #> 3:  <NA>     NA    NA  <NA>  <NA>     <NA>     <NA>   <NA>   <NA>   <NA>     NA
    #> 4:  <NA>     NA    NA  <NA>  <NA>     <NA>     <NA>   <NA>   <NA>   <NA>     NA
    #> 5:  <NA>     NA    NA  <NA>  <NA>     <NA>     <NA>   <NA>   <NA>   <NA>     NA
    #> 6:  <NA>     NA    NA  <NA>  <NA>     <NA>     <NA>   <NA>   <NA>   <NA>     NA
    #>    BUSPNTR RPTBFLAG FIREFLAG CONSZONE GOVTPROP MATLSPIL NARRFLAG PHOTFLAG
    #> 1:    <NA>     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>
    #> 2:    <NA>     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>
    #> 3:    <NA>     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>
    #> 4:    <NA>     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>
    #> 5:    <NA>     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>
    #> 6:    <NA>     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>
    #>    TRLRPNTR WITFLAG HITRUN HWYDIST STPTLNB AGCYNMBR ACSCNTL RLTNRDWY ROADHOR
    #> 1:     <NA>    <NA>   <NA>      NA    <NA>     <NA>    <NA>     <NA>    <NA>
    #> 2:     <NA>    <NA>   <NA>      NA    <NA>     <NA>    <NA>     <NA>    <NA>
    #> 3:     <NA>    <NA>   <NA>      NA    <NA>     <NA>    <NA>     <NA>    <NA>
    #> 4:     <NA>    <NA>   <NA>      NA    <NA>     <NA>    <NA>     <NA>    <NA>
    #> 5:     <NA>    <NA>   <NA>      NA    <NA>     <NA>    <NA>     <NA>    <NA>
    #> 6:     <NA>    <NA>   <NA>      NA    <NA>     <NA>    <NA>     <NA>    <NA>
    #>    ROADVERT TRFCWAY LATDEG LATMIN LONDEG LONMIN LATSEC LONSEC LONDECDG LATDECDG
    #> 1:     <NA>    <NA>     NA     NA     NA     NA     NA     NA       NA       NA
    #> 2:     <NA>    <NA>     NA     NA     NA     NA     NA     NA       NA       NA
    #> 3:     <NA>    <NA>     NA     NA     NA     NA     NA     NA       NA       NA
    #> 4:     <NA>    <NA>     NA     NA     NA     NA     NA     NA       NA       NA
    #> 5:     <NA>    <NA>     NA     NA     NA     NA     NA     NA       NA       NA
    #> 6:     <NA>    <NA>     NA     NA     NA     NA     NA     NA       NA       NA
    #>    URBCLASS NTFYDATE ENFTYPE ENFNAME JRSDTN ARHOUR ARMIN NTFYHOUR NTFYMIN
    #> 1:     <NA>     <NA>    <NA>    <NA>   <NA>     NA    NA       NA      NA
    #> 2:     <NA>     <NA>    <NA>    <NA>   <NA>     NA    NA       NA      NA
    #> 3:     <NA>     <NA>    <NA>    <NA>   <NA>     NA    NA       NA      NA
    #> 4:     <NA>     <NA>    <NA>    <NA>   <NA>     NA    NA       NA      NA
    #> 5:     <NA>     <NA>    <NA>    <NA>   <NA>     NA    NA       NA      NA
    #> 6:     <NA>     <NA>    <NA>    <NA>   <NA>     NA    NA       NA      NA
    #>    OFFRID CITFLAG ALCFLAG DRUGFLAG MCFLNMBR DOCTNMBR OPCODE SPCL1 SPCL2 SPCL3
    #> 1:   <NA>    <NA>    <NA>     <NA>     <NA>     <NA>   <NA>    NA    NA    NA
    #> 2:   <NA>    <NA>    <NA>     <NA>     <NA>     <NA>   <NA>    NA    NA    NA
    #> 3:   <NA>    <NA>    <NA>     <NA>     <NA>     <NA>   <NA>    NA    NA    NA
    #> 4:   <NA>    <NA>    <NA>     <NA>     <NA>     <NA>   <NA>    NA    NA    NA
    #> 5:   <NA>    <NA>    <NA>     <NA>     <NA>     <NA>   <NA>    NA    NA    NA
    #> 6:   <NA>    <NA>    <NA>     <NA>     <NA>     <NA>   <NA>    NA    NA    NA
    #>    SPCL4 TRKFLAG AUTOFLAG CYCLFLAG MOPFLAG PEDFLAG BUSFLAG BIKEFLAG TRLRFLAG
    #> 1:    NA    <NA>     <NA>     <NA>    <NA>    <NA>    <NA>     <NA>     <NA>
    #> 2:    NA    <NA>     <NA>     <NA>    <NA>    <NA>    <NA>     <NA>     <NA>
    #> 3:    NA    <NA>     <NA>     <NA>    <NA>    <NA>    <NA>     <NA>     <NA>
    #> 4:    NA    <NA>     <NA>     <NA>    <NA>    <NA>    <NA>     <NA>     <NA>
    #> 5:    NA    <NA>     <NA>     <NA>    <NA>    <NA>    <NA>     <NA>     <NA>
    #> 6:    NA    <NA>     <NA>     <NA>    <NA>    <NA>    <NA>     <NA>     <NA>
    #>    CMVFLAG
    #> 1:    <NA>
    #> 2:    <NA>
    #> 3:    <NA>
    #> 4:    <NA>
    #> 5:    <NA>
    #> 6:    <NA>

## Crash flags

Flags can be found: + deer\_flag (old & new db) + distracted\_flag (new
db) + impaireddriver\_flag (new db) + speed\_flag (old & new db) +
teendriver\_flag (new db) + olderdriver\_flag (new db) +
get\_seatbelt\_flag\_by\_unit + get\_drug\_alc\_suspected

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

## Relabel functions

-   get\_crash\_times(any\_df) - newtime
-   get\_age\_groups(person\_df) - age\_group
-   county\_rename(any\_df) - countyname
-   bin\_injury\_persons(person\_df) - inj - bins into Killed, Injured,
    No Injury
