#' Data Options
#'
#' Function showing which datasets are supported by the `read_data` function.
#'
#' @return List of datasets
#' @export
#'
#' @examples
#'
#' data_options()
#'
data_options <- function(){
  output <- paste0(
    "The following datasets are supported through `read_data`:\n",
    "   pophealth: Fictional healthcare dataset\n",
    "   datascience: Random job posting data from Glassdoor for data science positions from January, 2019\n",
    "   college: Most recent institution-level data from the US Department of Education College Scorecard (https://collegescorecard.ed.gov/data/)"
    )
  writeLines(output)
}
