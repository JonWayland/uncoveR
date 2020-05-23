#' Fitting the form for scaling features
#'
#' @param dat Dataframe with continuous variables intended for scaling
#' @param remove.me Vector of variable names to be excluded from scaling
#' @param exclude.binary Boolean determining whether to exclude scaling binary features that are measured as numeric. Default is TRUE.
#'
#' @return Returns information about each feature needed for scaling.
#' @export
#'
#' @examples
#' std.fit <- scale_form(iris, remove.me = c("Sepal.Width"))
#' iris2 <- scale_make(iris, std.fit, scaler = "standard")
#' head(iris2)
scale_form <- function(dat, remove.me = c(), exclude.binary = TRUE){
  # Determining which features need to be scaled
  scaleCols <- function(x){
    if(exclude.binary){
      is.numeric(x) & length(unique(x)) > 2
    }
    else{
      is.numeric(x)
    }
  }

  ind <- sapply(dat, scaleCols)

  # Determining which fields to keep based on the remove.me argument
  keep.fields <- names(dat[,ind])[!names(dat[,ind]) %in% remove.me]

  # Function for building the mean/stdev for each feature
  myScales <- function(dat){
    scalers <- data.frame(
      COL_NAME = names(dat),
      COL_MEAN = 0,
      COL_SD = 0,
      COL_MIN = 0,
      COL_MAX = 0
    )

    for(i in 1:ncol(dat)){
      scalers$COL_MEAN[i] <- mean(dat[,i])
      scalers$COL_SD[i] <- sd(dat[,i])
      scalers$COL_MIN[i] <- min(dat[,i])
      scalers$COL_MAX[i] <- max(dat[,i])
    }
    return(scalers)
  }

  # Finding the scales needed
  trainScales <- myScales(dfr[,keep.fields])
  return(trainScales)
}
