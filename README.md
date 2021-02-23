
<!-- README.md is generated from README.Rmd. Please edit that file -->

# wisdotcrashdatabase

<!-- badges: start -->
<!-- badges: end -->

The goal of wisdotcrashdatabase is to make data pulls and data analysis
much easier. At my job, it is a SAS environment. I switched to R for my
analysis. To set up an R environment, I converted the entire database
into CSVs. I wrote automated scripts for these. Haven package is an
option, but a couple things were not working properly. This package has
functions to get certain crash flags, relabel by age or injury type for
easier grouping.

## Installation

This package will never be released to CRAN as it’s used internally at
WisDOT.

The package can be installed from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jacciz/wisdotcrashdatabase")
```

## Importing data

This is done with one function:

``` r
library(wisdotcrashdatabase)
get_db_data(filepath = "C:/CSV/csv_from_sas/fst/", db_type = "crash", years_old = c("15", "16"), years = c("17","18"),  columns = c("ROLE"))
#>          CRSHNMBR   CRSHDATE         CRSHSVR CRSHTIME_GROUP  MUNICODE  CNTYCODE
#>      1: 170700471 2017-07-03          Injury           <NA>      <NA>      <NA>
#>      2: 170311367 2017-03-07 Property Damage           <NA>      <NA>      <NA>
#>      3: 170808687 2017-08-26 Property Damage           <NA>      <NA>      <NA>
#>      4: 170602026 2017-06-06 Property Damage           <NA>      <NA>      <NA>
#>      5: 171207544 2017-12-19 Property Damage           <NA>      <NA>      <NA>
#>     ---                                                                        
#> 534742: 161217058 2016-12-17          Injury       9-10  PM    DARIEN  Walworth
#> 534743: 161217059 2016-12-14           Fatal       9-10  AM    RACINE    Racine
#> 534744: 161217060 2016-12-18 Property Damage       4-5   PM MILWAUKEE Milwaukee
#> 534745: 161217061 2016-12-01          Injury       4-5   PM MILWAUKEE Milwaukee
#> 534746: 161217063 2016-12-16 Property Damage       6-7   AM MILWAUKEE Milwaukee
#>         MUNITYPE      POPCLASS CRSHMTH DAYNMBR TOTINJ TOTFATL TOTVEH TOTUNIT
#>      1:     <NA>          <NA>    <NA>    <NA>     NA      NA     NA      NA
#>      2:     <NA>          <NA>    <NA>    <NA>     NA      NA     NA      NA
#>      3:     <NA>          <NA>    <NA>    <NA>     NA      NA     NA      NA
#>      4:     <NA>          <NA>    <NA>    <NA>     NA      NA     NA      NA
#>      5:     <NA>          <NA>    <NA>    <NA>     NA      NA     NA      NA
#>     ---                                                                     
#> 534742:     TOWN       UNKNOWN     DEC     SAT      1       0      1       1
#> 534743:     CITY 50000 - 99999     DEC     WED      2       1      2       3
#> 534744:     CITY       UNKNOWN     DEC     SUN      0       0      2       2
#> 534745:     CITY       UNKNOWN     DEC     THU      1       0      1       2
#> 534746:     CITY       UNKNOWN     DEC     FRI      0       0      2       2
#>                           CRSHTYPE      LGTCOND WTHRCOND   ROADCOND
#>      1:                       <NA>         <NA>     <NA>       <NA>
#>      2:                       <NA>         <NA>     <NA>       <NA>
#>      3:                       <NA>         <NA>     <NA>       <NA>
#>      4:                       <NA>         <NA>     <NA>       <NA>
#>      5:                       <NA>         <NA>     <NA>       <NA>
#>     ---                                                            
#> 534742:               UTILITY POLE   DARK/UNLIT     SNOW SNOW/SLUSH
#> 534743:                 PEDESTRIAN     DAYLIGHT   CLOUDY        WET
#> 534744: MOTOR VEHICLE IN TRANSPORT     DAYLIGHT    CLEAR SNOW/SLUSH
#> 534745:                 PEDESTRIAN DARK/LIGHTED   CLOUDY        DRY
#> 534746: MOTOR VEHICLE IN TRANSPORT     DAYLIGHT     SNOW SNOW/SLUSH
#>                        MNRCOLL            HWYCLASS URBRURAL ONHWY ONHWYDIR
#>      1:                   <NA>                <NA>     <NA>  <NA>     <NA>
#>      2:                   <NA>                <NA>     <NA>  <NA>     <NA>
#>      3:                   <NA>                <NA>     <NA>  <NA>     <NA>
#>      4:                   <NA>                <NA>     <NA>  <NA>     <NA>
#>      5:                   <NA>                <NA>     <NA>  <NA>     <NA>
#>     ---                                                                   
#> 534742: NO COLL W/VEH IN TRANS     TOWN ROAD RURAL        0               
#> 534743: NO COLL W/VEH IN TRANS STATE HIGHWAY URBAN        4   020         
#> 534744:                  ANGLE   CITY STREET URBAN        0               
#> 534745:                HEAD ON   CITY STREET URBAN        0               
#> 534746:                  ANGLE   CITY STREET URBAN        0               
#>         ONHWYTYP                 ONSTR RPNMBR RPDIS             ATSTR ATHWY
#>      1:     <NA>                  <NA>     NA    NA              <NA>  <NA>
#>      2:     <NA>                  <NA>     NA    NA              <NA>  <NA>
#>      3:     <NA>                  <NA>     NA    NA              <NA>  <NA>
#>      4:     <NA>                  <NA>     NA    NA              <NA>  <NA>
#>      5:     <NA>                  <NA>     NA    NA              <NA>  <NA>
#>     ---                                                                    
#> 534742:                      OLD 89 RD     NA     0 SCHOOL SECTION RD      
#> 534743:                 WASHINGTON AVE     NA     0         OREGON ST      
#> 534744:                W FIEBRANTZ AVE     NA     0         N 64TH ST      
#> 534745:          N MOTHERS DANIELS WAY     NA     0     W HAMPTON AVE      
#> 534746:                      N 24TH PL     NA     0     W BURLEIGH ST      
#>         ATHWYDIR ATHWYTYP ATNMBR ATCODE INTDIR INTDIS BUSPNTR RPTBFLAG FIREFLAG
#>      1:     <NA>     <NA>   <NA>   <NA>   <NA>     NA    <NA>     <NA>     <NA>
#>      2:     <NA>     <NA>   <NA>   <NA>   <NA>     NA    <NA>     <NA>     <NA>
#>      3:     <NA>     <NA>   <NA>   <NA>   <NA>     NA    <NA>     <NA>     <NA>
#>      4:     <NA>     <NA>   <NA>   <NA>   <NA>     NA    <NA>     <NA>     <NA>
#>      5:     <NA>     <NA>   <NA>   <NA>   <NA>     NA    <NA>     <NA>     <NA>
#>     ---                                                                        
#> 534742:     <NA>                             S     40       N        Y        N
#> 534743:     <NA>                             W      2       N        Y        N
#> 534744:     <NA>                                    0       N        Y        N
#> 534745:     <NA>            4834      O      N      6       N        Y        N
#> 534746:     <NA>                             N      3       N        Y        N
#>         CONSZONE GOVTPROP MATLSPIL NARRFLAG PHOTFLAG TRLRPNTR WITFLAG HITRUN
#>      1:     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>    <NA>   <NA>
#>      2:     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>    <NA>   <NA>
#>      3:     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>    <NA>   <NA>
#>      4:     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>    <NA>   <NA>
#>      5:     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>    <NA>   <NA>
#>     ---                                                                     
#> 534742:        N        N        N        Y        N        N       N      N
#> 534743:        N        N        N        Y        Y        N       N      N
#> 534744:        N        N        N        Y        N        N       N      Y
#> 534745:        N        N        N        Y        N        N       Y      Y
#> 534746:        N        N        N        Y        N        N       N      Y
#>         HWYDIST STPTLNB AGCYNMBR    ACSCNTL               RLTNRDWY  ROADHOR
#>      1:      NA    <NA>     <NA>       <NA>                   <NA>     <NA>
#>      2:      NA    <NA>     <NA>       <NA>                   <NA>     <NA>
#>      3:      NA    <NA>     <NA>       <NA>                   <NA>     <NA>
#>      4:      NA    <NA>     <NA>       <NA>                   <NA>     <NA>
#>      5:      NA    <NA>     <NA>       <NA>                   <NA>     <NA>
#>     ---                                                                    
#> 534742:       2       2          NO CONTROL OUTSIDE SHOULDER-RIGHT STRAIGHT
#> 534743:       2       2          NO CONTROL             ON ROADWAY STRAIGHT
#> 534744:       2       2          NO CONTROL             ON ROADWAY STRAIGHT
#> 534745:       0       0          NO CONTROL             ON ROADWAY STRAIGHT
#> 534746:       2       2          NO CONTROL             ON ROADWAY STRAIGHT
#>           ROADVERT                TRFCWAY LATDEG LATMIN LONDEG LONMIN  LATSEC
#>      1:       <NA>                   <NA>     NA     NA     NA     NA      NA
#>      2:       <NA>                   <NA>     NA     NA     NA     NA      NA
#>      3:       <NA>                   <NA>     NA     NA     NA     NA      NA
#>      4:       <NA>                   <NA>     NA     NA     NA     NA      NA
#>      5:       <NA>                   <NA>     NA     NA     NA     NA      NA
#>     ---                                                                      
#> 534742:       HILL NOT PHYSICALLY DIVIDED     42     37    -88     42 34.6142
#> 534743: LEVEL/FLAT NOT PHYSICALLY DIVIDED     42     43    -87     49  7.0129
#> 534744: LEVEL/FLAT NOT PHYSICALLY DIVIDED     43      5    -87     59 30.6701
#> 534745: LEVEL/FLAT NOT PHYSICALLY DIVIDED     43      6    -87     57 19.5479
#> 534746: LEVEL/FLAT NOT PHYSICALLY DIVIDED     43      4    -87     56 32.1274
#>          LONSEC  LONDECDG LATDECDG URBCLASS   NTFYDATE        ENFTYPE
#>      1:      NA        NA       NA     <NA>       <NA>           <NA>
#>      2:      NA        NA       NA     <NA>       <NA>           <NA>
#>      3:      NA        NA       NA     <NA>       <NA>           <NA>
#>      4:      NA        NA       NA     <NA>       <NA>           <NA>
#>      5:      NA        NA       NA     <NA>       <NA>           <NA>
#>     ---                                                              
#> 534742: 32.4009 -88.70900 42.62628    RURAL 12/17/2016 COUNTY SHERIFF
#> 534743: 57.8781 -87.83274 42.71861    URBAN 12/14/2016    CITY POLICE
#> 534744: 31.2657 -87.99202 43.09185    URBAN 12/18/2016    CITY POLICE
#> 534745: 23.6232 -87.95656 43.10543    URBAN 12/01/2016    CITY POLICE
#> 534746: 36.7538 -87.94354 43.07559    URBAN 12/16/2016    CITY POLICE
#>                             ENFNAME    JRSDTN ARHOUR ARMIN NTFYHOUR NTFYMIN
#>      1:                        <NA>      <NA>     NA    NA       NA      NA
#>      2:                        <NA>      <NA>     NA    NA       NA      NA
#>      3:                        <NA>      <NA>     NA    NA       NA      NA
#>      4:                        <NA>      <NA>     NA    NA       NA      NA
#>      5:                        <NA>      <NA>     NA    NA       NA      NA
#>     ---                                                                    
#> 534742:     WALWORTH COUNTY SHERIFF  WALWORTH     21    25       21       9
#> 534743:    RACINE POLICE DEPARTMENT    RACINE      9    52        9      51
#> 534744: MILWAUKEE POLICE DEPARTMENT MILWAUKEE     16    55       16      55
#> 534745: MILWAUKEE POLICE DEPARTMENT MILWAUKEE     20     0       19      40
#> 534746: MILWAUKEE POLICE DEPARTMENT MILWAUKEE      6    36        6      32
#>         OFFRID CITFLAG ALCFLAG DRUGFLAG    MCFLNMBR DOCTNMBR OPCODE SPCL1 SPCL2
#>      1:   <NA>    <NA>    <NA>     <NA>        <NA>     <NA>   <NA>    NA    NA
#>      2:   <NA>    <NA>    <NA>     <NA>        <NA>     <NA>   <NA>    NA    NA
#>      3:   <NA>    <NA>    <NA>     <NA>        <NA>     <NA>   <NA>    NA    NA
#>      4:   <NA>    <NA>    <NA>     <NA>        <NA>     <NA>   <NA>    NA    NA
#>      5:   <NA>    <NA>    <NA>     <NA>        <NA>     <NA>   <NA>    NA    NA
#>     ---                                                                        
#> 534742:              N       N        N 1600H71L65T  H71L65T   6046    NA    NA
#> 534743:              Y       N        N 1600LT76BDQ  LT76BDQ   1351    NA    NA
#> 534744:              N       N        N 1600QPXRQSP  QPXRQSP  NO ID    NA    NA
#> 534745:              N       N        N 1600QQ4WFRZ  QQ4WFRZ  16633    NA    NA
#> 534746:              N       N        N 1600QPSN1LP  QPSN1LP  NO ID    NA    NA
#>         SPCL3 SPCL4 TRKFLAG AUTOFLAG CYCLFLAG MOPFLAG PEDFLAG BUSFLAG BIKEFLAG
#>      1:    NA    NA    <NA>     <NA>     <NA>    <NA>    <NA>    <NA>     <NA>
#>      2:    NA    NA    <NA>     <NA>     <NA>    <NA>    <NA>    <NA>     <NA>
#>      3:    NA    NA    <NA>     <NA>     <NA>    <NA>    <NA>    <NA>     <NA>
#>      4:    NA    NA    <NA>     <NA>     <NA>    <NA>    <NA>    <NA>     <NA>
#>      5:    NA    NA    <NA>     <NA>     <NA>    <NA>    <NA>    <NA>     <NA>
#>     ---                                                                       
#> 534742:    NA    NA       Y        N        N       N       N       N        N
#> 534743:    NA    NA       Y        Y        N       N       Y       N        N
#> 534744:    NA    NA       N        Y        N       N       N       N        N
#> 534745:    NA    NA       N        Y        N       N       Y       N        N
#> 534746:    NA    NA       N        Y        N       N       N       N        N
#>         TRLRFLAG CMVFLAG
#>      1:     <NA>    <NA>
#>      2:     <NA>    <NA>
#>      3:     <NA>    <NA>
#>      4:     <NA>    <NA>
#>      5:     <NA>    <NA>
#>     ---                 
#> 534742:        N       N
#> 534743:        N       Y
#> 534744:        N       N
#> 534745:        N       N
#> 534746:        N       N
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

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

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/master/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
