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
    v_mu <- mean(v_new) # calculates mean for vector without value i
    v_cut <- 3*sd(v_new) # 3 times the standard deviation for vector without value i
    if(v[i] < v_mu - v_cut | v[i] > v_mu + v_cut){ # If value i is less than or greater than 3 times the vector without value i then it is an outlier
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
