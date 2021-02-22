# usethis::use_r("import_data_") # make new R
# devtools::document() # for after insert Roxygen skeleton, updates NAMESPACE
# pkgload::load_all()  - ctrl shift l
# devtools::check()
# usethis::use_github() # New repo
# install() to install into library
# usethis::use_test("read_cols") to test functions (use Build pane)
# usethis::use_package("forcats") # add packages to 'Imports'
# build_readme() # Render readme.md



#'
#'
#' lookup_table <- tribble(
#'   ~where, ~english,
#'   "beach",     "US",
#'   "coast",     "US",
#'   "seashore",     "UK",
#'   "seaside",     "UK"
#' )
#'
#' dat <- dat %>%
#'   left_join(lookup_table)
#' #> Joining, by = "where"
#'
#' # Or put this in a csv and put in a helper.R and source() it
#' #' export
#' localize_beach <- function(dat) {
#'   lookup_table <- read_csv(
#'     "beach-lookup-table.csv",
#'     col_types = cols(where = "c", english = "c")
#'   )
#'   left_join(dat, lookup_table)
#' }
#'
#' # In the function
#' (dat <- dat %>%
#'     localize_beach() %>%
#'     celsify_temp())
#'
#' # option 1 (then you should also put utils in Imports)
#' utils::globalVariables(c("english", "temp"))



# 7.6 Constant health checks
# Here is a typical sequence of calls when using devtools for package development:
#
# Edit one or more files below R/.
# document() (if you’ve made any changes that impact help files or NAMESPACE)
# load_all()
# Run some examples interactively.
# test() (or test_file())
# check()
