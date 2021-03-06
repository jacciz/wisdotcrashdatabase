% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_age_groups.R
\name{get_age_groups}
\alias{get_age_groups}
\title{Bin age groups by 5 or 10 years (old and new db)}
\usage{
get_age_groups(person_df, bin_by = "5_yr", age_column = "AGE")
}
\arguments{
\item{person_df}{person dataframe}

\item{bin_by}{select either "5_yr", "10_yr", or "old_db_yr"}

\item{age_column}{age column}
}
\value{
A new column called \emph{age_group_5yr}, \emph{age_group_10yr} or
\emph{age_groups_both}
}
\description{
This bins ages into age groups by 5 years or 10 years. If bin_by =
"old_db_yr", this will allow for old and new db age groups to be combined.
This just matches with the old db AGE.
}
\examples{
\dontrun{get_age_groups(person17, bin_by = "10_yr"}
}
