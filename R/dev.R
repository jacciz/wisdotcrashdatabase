# usethis::use_r("import_data") # make new R
# devtools::document() # for after insert Roxygen skeleton, updates NAMESPACE. ctrl shift b
# usethis::use_package("forcats") # add packages to 'Imports'

# pkgload::load_all()  - ctrl shift l loads everything in the package
# devtools::check()
# devtools::test() ctrl shift t
# usethis::use_github() # New repo
# install() to install into library
# usethis::use_test("read_cols") to test functions (use Build pane)

# devtools::build_readme() # Render readme.md
# devtools::build_manual(path = "c:/W_shortcut/wisdotcrashdatabase")path = "c:/W_shortcut/wisdotcrashdatabase") # Render PDF manual
# R CMD Rd2pdf c:/W_shortcut/wisdotcrashdatabase
#tinytex::latexmk()
# tinytex::latexmk("C:/W_shortcut/wisdotcrashdatabase/.Rd2pdf21644/Rd2.tex")
# devtools::build(manual = TRUE) # builds a tar.gz
# ctrl shift / -makes everything 80 characters

# importFrom dplyr left_join filter mutate


# 7.6 Constant health checks
# Here is a typical sequence of calls when using devtools for package development:
#
# Edit one or more files below R/.
# devtools::document() (if you’ve made any changes that impact help files or NAMESPACE)
# devtools::load_all() # load package into env
# Run some examples interactively.
# devtools::test()
# test() (or test_file())
# devtools::check()
