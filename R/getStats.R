#' getStats
#'
#' Gets standard statistics from a dataset
#'
#' @param dat Dataframe
#'
#' @return Statistics on the inputted dataset
#' @export
#'
#' @examples
#' getStats(mtcars)
getStats <- function(dat){
  if(!is.data.frame(dat)){stop(paste0(deparse(substitute(dat))," is not a dataframe"))}

  tukeyHigh <- function(v){
    IQR <- quantile(v,0.75, na.rm = TRUE)-quantile(v,0.25, na.rm = TRUE)
    1.5*IQR+quantile(v,0.75, na.rm = TRUE)
  }
  tukeyLow <- function(v){
    IQR <- quantile(v,0.75, na.rm = TRUE)-quantile(v,0.25, na.rm = TRUE)
    quantile(v,0.25, na.rm = TRUE) - 1.5*IQR
  }

  # Checking for potential outliers
  numFields <- c()
  for(nm in names(dat)){
    if(is.numeric(dat[nm][,1])){
      numFields <- append(numFields, nm)
    }
  }
  high.list <- c()
  for(i in 1:length(numFields)){
    high.list <- append(which(dat[,numFields[i]] > tukeyHigh(dat[,numFields[i]])),high.list)
  }
  low.list <- c()
  for(i in 1:length(numFields)){
    low.list <- append(which(dat[,numFields[i]] > tukeyHigh(dat[,numFields[i]])),low.list)
  }

  # Combining
  outlier.cnt <- length(unique(append(low.list, high.list)))

  # Checking whether a column is a date
  is.Date <- function(x){is(x, "Date")}

  row.cnt <- nrow(dat)
  col.cnt <- ncol(dat)
  size <- utils::object.size(dat)

  numeric.cnt <- sum(sapply(dat, is.numeric), na.rm = TRUE)
  factor.cnt <- sum(sapply(dat, is.factor), na.rm = TRUE)
  date.cnt <- sum(sapply(dat, is.Date), na.rm = TRUE)
  integer.cnt <- sum(sapply(dat, is.integer), na.rm = TRUE)
  character.cnt <- sum(sapply(dat, is.character), na.rm = TRUE)
  logical.cnt <- sum(sapply(dat, is.logical), na.rm = TRUE)
  complex.cnt <- sum(sapply(dat, is.complex), na.rm = TRUE)

  numeric.message <- ifelse(numeric.cnt == 1, " column is a numeric variable\n", " columns are numeric variables\n")
  factor.message <- ifelse(factor.cnt == 1, " column is a factor variable\n", " columns are factor variables\n")
  date.message <- ifelse(date.cnt == 1, " column is a date variable\n", " columns are date variables\n")
  integer.message <- ifelse(integer.cnt == 1, " column is an integer variable\n", " columns are integer variables\n")
  character.message <- ifelse(character.cnt == 1, " column is a character variable\n", " columns are character variables\n")
  logical.message <- ifelse(logical.cnt == 1, " column is a logical variable\n", " columns are logical variables\n")
  complex.message <- ifelse(complex.cnt == 1, " column is a complex variable\n", " columns are complex variables\n")

  noVarCols <- function(dat) {
    catLengths <- lapply(dat, function(x) length(unique(x)))
    noVarCols <- which(catLengths <= 1)
    unlist(noVarCols)
  }

  noVar.cnt <- length(noVarCols(dat))


  output <- paste0(
    "High-level statistics for the ",deparse(substitute(dat))," dataset:\n",
    "   Total Rows: ",prettyNum(row.cnt,big.mark=",",scientific=FALSE),"\n",
    "   Total Columns: ",prettyNum(col.cnt,big.mark=",",scientific=FALSE),"\n",
    ifelse(numeric.cnt>0,paste0("     - ", numeric.cnt, numeric.message),""),
    ifelse(factor.cnt>0,paste0("     - ", factor.cnt, factor.message),""),
    ifelse(date.cnt>0,paste0("     - ", date.cnt, date.message),""),
    ifelse(integer.cnt>0,paste0("     - ", integer.cnt, integer.message),""),
    ifelse(character.cnt>0,paste0("     - ", character.cnt, character.message),""),
    ifelse(logical.cnt>0,paste0("     - ", logical.cnt, logical.message),""),
    ifelse(complex.cnt>0,paste0("     - ", complex.cnt, complex.message),""),
    "   Estimated Size: ",prettyNum(size,big.mark=",",scientific=FALSE)," bytes","\n",
    "   Total Potential Outlying Observations: ", prettyNum(outlier.cnt,mark=",",scientific=FALSE), "\n",
    "   Total Number of Columns with No Variance: ", prettyNum(noVar.cnt, mark=",",scientific=FALSE)
  )
  writeLines(output)
}
