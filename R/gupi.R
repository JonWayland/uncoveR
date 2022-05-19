#' Guilty Until Proven Innocent
#'
#' @param v vector of numeric values to assess whether outliers exist
#'
#' @return dataframe with two columns: `index` and `value`. The `index` column represents which row contains the outlier, while the `value` row contains the outlying value
#' @export
#'
#' @examples
#' iris[gupi(iris$Sepal.Width)$index,]
#'
gupi <- function(v){
  outliers <- data.frame(index = as.numeric(), value = as.numeric())
  for(i in 1:length(v)){
    v_new <- v[-i]
    v_mu <- mean(v_new)
    v_cut <- 3*sd(v_new)
    if(v[i] < v_mu - v_cut | v[i] > v_mu + v_cut){
      outliers <- rbind(outliers, data.frame(
        index = i, value = v[i]
      ))
    }
  }
  if(nrow(outliers) > 0){
    return(outliers)
  } else{
    writeLines("No outliers")
  }
}
