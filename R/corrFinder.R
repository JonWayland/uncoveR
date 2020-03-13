#' Finding pairwise and average correlations
#'
#' @param dat Dataframe with at least two numeric columns
#' @param strongest Boolean indicating whether to order the output by the strongest absolute correlations (default is TRUE)
#' @param weakest Boolean indicating whether to order the output by the weakest absolute correlations (default is FALSE)
#'
#' @return Returns a dataframe storing all pairwise Pearson correlation coefficients and corresponding p-values, as well as average correlation by variable
#' @export
#'
#' @examples
#' corrFinder(iris)
corrFinder <- function(dat, strongest = TRUE, weakest = FALSE){

  # Determining which fields are numeric
  numFields <- c()
  for(nm in names(dat)){
    if(is.numeric(dat[nm][,1])){
      numFields <- append(numFields, nm)
    }
  }

  # Deriving the key values
  dfr <- data.frame(Var1 = as.character(), Var2 = as.character(), correlation = as.numeric(), p_value = as.numeric())

  for(i in 1:length(numFields)){
    for(j in 1:length(numFields)){
      if(i > j){
        Var1 = numFields[i]
        Var2 = numFields[j]

        cor.val <- as.numeric(cor.test(dat[,numFields[i]], dat[,numFields[j]])$est)
        p.val <- as.numeric(cor.test(dat[,numFields[i]], dat[,numFields[j]])$p.value)

        dfr <- rbind(dfr, data.frame(Var1 = Var1, Var2 = Var2, correlation = cor.val, p_value = p.val))
      }
    }
  }

  # Determining rank of average correlation with all variables
  dfr$var1_avg_cor <- NA
  dfr$var2_avg_cor <- NA

  for(i in 1:length(numFields)){
    avg_cor <- mean(dfr$correlation[dfr$Var1 == numFields[i] | dfr$Var2 == numFields[i]])
    dfr$var1_avg_cor[dfr$Var1 == numFields[i]] <- avg_cor
    dfr$var2_avg_cor[dfr$Var2 == numFields[i]] <- avg_cor
  }

  # Ordering the results appropriately
  if(strongest){
    # Ordering by the absolute value of the coefficient (descending)
    dfr <- dfr[order(-abs(dfr$correlation)),]
  }
  if(weakest){
    # Ordering by the absolute value of the coefficient (ascending)
    dfr <- dfr[order(abs(dfr$correlation)),]
  }

  return(dfr)
}

