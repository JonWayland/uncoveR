#' Reading open-sourced data
#'
#' This function is set up to pull open sourced datasets from the web.
#'
#' @param open_dat Character string specifying the dataset the user wishes to read. Use `uncoveR::data_options()` to see the dataset options available.
#'
#' @return Dataframe object containing the data specified.
#' @export
#'
#' @examples
#' healthDat <- read_data('pophealth')
#' dataSci <- read_data('datascience')
read_data <- function(open_dat = ""){

  if(open_dat == ""){stop("There is no dataset specified. Please choose a supported dataset. You can use data_options() to see what is available.")}

  if(open_dat == 'pophealth'){
    writeLines('Reading the pophealth data set from the following GitHub repository: https://github.com/JonWayland/Fake-Healthcare..')
    pophealth <- read.csv("https://raw.githubusercontent.com/JonWayland/Fake-Healthcare/master/HP-Universal_DF.csv")
    getStats(pophealth)
    return(pophealth)
  }

  if(open_dat == 'datascience'){
    writeLines('Reading the datascience data set from the following GitHub repository: https://github.com/JonWayland/Opening-Glassdoor..')
    datascience <- read.csv("https://raw.githubusercontent.com/JonWayland/Opening-Glassdoor/master/DSdata.csv")
    getStats(datascience)
    return(datascience)
  }

  if(open_dat == 'college'){
    writeLines('Reading the college data set from the US Department of Education: https://collegescorecard.ed.gov/data..')
    college <- read.csv("https://ed-public-download.app.cloud.gov/downloads/Most-Recent-Cohorts-All-Data-Elements.csv")
    getStats(college)
    return(college)
  }

  if(open_dat == 'study'){
    writeLines('Reading the field of study data set from the US Department of Education: https://collegescorecard.ed.gov/data..')
    study <- read.csv("https://ed-public-download.app.cloud.gov/downloads/Most-Recent-Field-Data-Elements.csv")
    getStats(study)
    return(study)
  }

}
