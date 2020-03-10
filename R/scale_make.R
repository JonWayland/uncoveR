#' Making the scales on new data
#'
#' @param dat Dataframe with continuous variables intended for scaling (uses distribution from training data)
#' @param scale_data The object created from calling `scale_form`
#' @param scaler Method for scaling. Options include: 'standard', 'minmax'
#'
#' @return Returns the original dataset `dat` with the desired numeric features scaled using the `scaler` method.
#' @export
#'
#' @examples
#' std.fit <- scale_form(iris, remove.me = c("Sepal.Width"))
#' iris2 <- scale_make(iris, std.fit, scaler = "standard")
#' head(iris2)
scale_make <- function(dfr, scale_data = trainScales, scaler = NA){

  if(!scaler %in% c("minmax", "standard")){
    writeLines("No valid method selected. Using standardization (scaler = 'standard').")
    warning("If you would like to use a minmax scaler then set scaler = 'minmax' ")
  }

  # Loop through all of trainScales
  for(i in 1:nrow(scale_data)){
    for(j in 1:ncol(dfr)){
      # Get the name of the variable from dfr
      if(names(dfr)[j] == scale_data$COL_NAME[i]){
        if(scaler == "standard"){
          dfr[,j] <- (dfr[,j] - scale_data$COL_MEAN[i]) / scale_data$COL_SD[i]
        }
        if(scaler == "minmax"){
          dfr[,j] <- (dfr[,j] - scale_data$COL_MIN[i]) / (scale_data$COL_MAX[i] - scale_data$COL_MIN[i])
        }
        if(!scaler %in% c("standard", "minmax")){
          dfr[,j] <- (dfr[,j] - scale_data$COL_MEAN[i]) / scale_data$COL_SD[i]
        }
      }
    }
  }
  return(dfr)
}
