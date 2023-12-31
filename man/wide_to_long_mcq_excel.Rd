% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{wide_to_long_mcq_excel}
\alias{wide_to_long_mcq_excel}
\title{Reshape MCQ data from wide (as used in the 21- and 27-Item
Monetary Choice Questionnaire Automated Scorer) to long}
\usage{
wide_to_long_mcq_excel(dat)
}
\arguments{
\item{dat}{Wide format MCQ data as used in the Excel Automated Scorers}
}
\value{
Long format data frame
}
\description{
Reshape MCQ data from wide (as used in the 21- and 27-Item
Monetary Choice Questionnaire Automated Scorer) to long
}
\examples{
wide_to_long_mcq_excel(long_to_wide_mcq_excel(generate_data_mcq(2)))

}
