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
scale_form <- function(dfr, remove.me = c(), exclude.binary = TRUE){
  # Determining which features need to be scaled
  scaleCols <- function(x){
    if(exclude.binary){
      is.numeric(x) & length(unique(x)) > 2
    }
    else{
      is.numeric(x)
    }
  }

  ind <- sapply(dfr, scaleCols)

  # Determining which fields to keep based on the remove.me argument
  keep.fields <- names(dfr[,ind])[!names(dfr[,ind]) %in% remove.me]

  # Function for building the mean/stdev for each feature
  myScales <- function(dfr){
    scalers <- data.frame(
      COL_NAME = names(dfr),
      COL_MEAN = 0,
      COL_SD = 0,
      COL_MIN = 0,
      COL_MAX = 0
    )

    for(i in 1:ncol(dfr)){
      scalers$COL_MEAN[i] <- mean(dfr[,i])
      scalers$COL_SD[i] <- sd(dfr[,i])
      scalers$COL_MIN[i] <- min(dfr[,i])
      scalers$COL_MAX[i] <- max(dfr[,i])
    }
    return(scalers)
  }

  # Finding the scales needed
  trainScales <- myScales(dfr[,keep.fields])
  return(trainScales)
}
