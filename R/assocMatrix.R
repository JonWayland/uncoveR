#' Creating an Association Matrix
#'
#' Using Cramer's V, the association matrix shows pair-wise relationships between categorical variables with up to a specified number of levels
#'
#' @param dat Dataframe with at least 2 categorical variables
#' @param n.levels Specifying the number of levels for all categorical variables to be considered (default is 6)
#' @param plotTitle Optional string specifying the title of the plot
#' @param val.label Boolean determining whether to add values of coefficients to the plot (default is FALSE)
#'
#' @return Heat map style plot displaying the strength of pair-wise associations in categorical variables
#' @export
#'
#' @examples
#' assocMatrix(mtcars)
assocMatrix <- function(dat, n.levels = 6, plotTitle = "default", val.label = FALSE){
  require(ggplot2)
  require(dplyr)

  plotTitle <- if(plotTitle == "default"){paste0("Association Matrix for the ",deparse(substitute(dat)) ," Dataset")} else{plotTitle}
  catFields <- c()
  for(nm in names(dat)){
    if(length(levels(factor(dat[nm][,1]))) <= n.levels & length(levels(factor(dat[nm][,1]))) > 1){
      catFields <- append(catFields, nm)
    }
  }

  dfr <- data.frame(Var1 = as.character(), Var2 = as.character(), cramersV_score = as.numeric())
  for(i in 1:length(catFields)){
    for(j in 1:length(catFields)){
      if(i >= j){
        Var1 = catFields[i]
        Var2 = catFields[j]

        test <- chisq.test(dat[,catFields[i]], dat[,catFields[j]], simulate.p.value = TRUE)
        chi2 <- test$statistic
        N <- sum(test$observed)
        if (test$method == "Chi-squared test for given probabilities") {
          ind <- which.min(test$expected)
          max.dev <- test$expected
          max.dev[ind] <- N - max.dev[ind]
          max.chi2 <- sum(max.dev^2/test$expected)
          cramersV_score <- sqrt(chi2/max.chi2)
        }
        else {
          k <- min(dim(test$observed))
          cramersV_score <- sqrt(chi2/(N * (k - 1)))
        }
        names(cramersV_score) <- NULL

        dfr <- rbind(dfr, data.frame(Var1 = Var1, Var2 = Var2, cramersV_score = cramersV_score))
      }
    }
  }

  # Recreating the values for each pair of variables
  dfr <- rbind(dfr, data.frame(Var1 = dfr$Var2, Var2 = dfr$Var1, cramersV_score = dfr$cramersV_score))

  # Reordering
  dfr$Var2 <- factor(dfr$Var2, levels = levels(dfr$Var1))

  # Tile Plot
  dfr %>%
    rowwise() %>%
    mutate(valLabel = ifelse(val.label,cramersV_score,NA)) %>%
    ggplot(aes(x=Var1,y=Var2,fill=cramersV_score))+
    geom_tile()+
    scale_fill_gradientn(name = "Cramer's V",
                         colors = c("white", "chartreuse2"),
                         limits = c(0.0, 1.0),
                         breaks = c(0.0, 1.0),
                         labels = c("0.0", "1.0"))+
    geom_text(aes(x = Var1, y = Var2, label = round(valLabel,2)))+
    scale_x_discrete(name = "")+
    scale_y_discrete(name = "")+
    ggtitle(plotTitle)+
    theme_classic() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

assocMatrix(mtcars, val.label = TRUE)
