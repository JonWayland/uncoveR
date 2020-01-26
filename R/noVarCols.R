
#' noVarCols
#'
#' Identifying all columns with no variance
#'
#' @param dat Dataframe
#'
#' @return Index positions for columns with no variance
#' @export
#'
#' @examples
#' sub_iris  <- iris[1:50,]
#' noVarCols(sub_iris)
#' sub_iris <- sub_iris[,-noVarCols(sub_iris)]
#'
noVarCols <- function(dat) {
  catLengths <- lapply(dat, function(x) length(unique(x)))
  noVarCols <- which(catLengths <= 1)
  unlist(noVarCols)
}
