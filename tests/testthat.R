# testthat::context("2017 Crash length")
testthat::test_that("2017 numb of crashes",
                    {
                      testthat::expect_equal(nrow(
                        get_db_data(
                          filepath = "C:/CSV/csv_from_sas/fst/",
                          db_type = "crash",
                          years = c("17")
                        )
                      ), 139870)
                    })


testthat::test_that("2016/2017 numb of crashes",
                    {
                      testthat::expect_equal(nrow(
                        get_db_data(
                          filepath = "C:/CSV/csv_from_sas/fst/",
                          db_type = "crash",
                          years = c("17"),
                          years_old = c("16")
                        )
                      ), 268921)
                    })


testthat::test_that("2016/2017 killed ppl",
                    {
                      testthat::expect_equal(nrow(
                        get_db_data(
                          filepath = "C:/CSV/csv_from_sas/fst/",
                          db_type = "person",
                          years = c("17"),
                          years_old = c("16"),
                          columns = "WISINJ"
                        ) %>% dplyr::filter(WISINJ == "Fatal Injury")
                      ), 1182)
                    })
testthat::test_that("2017 distracted crashes",
                    {
                      testthat::expect_equal(nrow(
                        get_db_data(
                          filepath = "C:/CSV/csv_from_sas/fst/",
                          db_type = "person",
                          years = c("17"),
                          columns = c("UNITNMBR","DISTACT", "DRVRDS","ROLE")
                        ) %>% get_distracted_driver_flag() %>%
                          dplyr::filter(distracted_flag == "Y") %>%
                          dplyr::distinct(CRSHNMBR)
                      ), 24192)
                    }) # 24,192 in 2017, 12,377 in 2019
testthat::test_that("2017 speed crashes",
                    {
                      testthat::expect_equal(nrow(
                        get_db_data(
                          filepath = "C:/CSV/csv_from_sas/fst/",
                          db_type = "person",
                          years = c("17"),
                          columns = c("UNITNMBR","DRVRFLAG", "DRVRPC", "STATNM","ROLE")
                        ) %>% get_speed_flag() %>%
                          dplyr::filter(speed_flag == "Y") %>%
                          dplyr::distinct(CRSHNMBR)
                      ), 19182)
                    }) # # 20,061 in 2018, 19,182 in 2017, 19,540 in 2016

testthat::test_that("2017 impaired person",
                    {
                      testthat::expect_equal(nrow(
                        get_db_data(
                          filepath = "C:/CSV/csv_from_sas/fst/",
                          db_type = "person",
                          years = c("17"),
                          columns = c("UNITNMBR","DRVRFLAG","ALCSUSP","DRUGSUSP","ROLE")
                        ) %>% get_alc_drug_impaired_person(driver_only = "Y", include_drug = "N") %>% dplyr::filter(alcohol_flag == "Y")), 6061)
                    })

#
#
# imp <- get_db_data(
#   filepath = "C:/CSV/csv_from_sas/fst/",
#   db_type = "person",
#   years = c("17"),
#   columns = c("ROLE", "DRVRFLAG", "UNITNMBR","ALCSUSP","DRUGSUSP","CUSTNMBR", "SEX", "WISINJ"))
