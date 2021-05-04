#' Guilty Until Proven Innocent
#'
#' @param v
#'
#' @return
#' @export
#'
#' @examples
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
