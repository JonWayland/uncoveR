#' Correlation Matrix
#'
#' @param dat Dataframe with at least 2 numeric variables
#' @param plotTitle Optional string specifying the title of the plot
#' @param val.label Boolean determining whether to add values of coefficients to the plot (default is FALSE)
#' @param output Specifying whether the output is to be a plot of raw data (default is plot)
#'
#' @return Heat map style plot displaying the strength of pair-wise correlations in numeric variables
#' @export
#'
#' @examples
#' corrMatrix(iris)
corrMatrix <- function(dat, plotTitle = "default", val.label = FALSE, output = 'plot'){
  require(dplyr)
  require(ggplot2)

  plotTitle <- if(plotTitle == "default"){paste0("Correlation Matrix for the ",deparse(substitute(dat)) ," Dataset")} else{plotTitle}
  numFields <- c()
  for(nm in names(dat)){
    if(is.numeric(dat[nm][,1])){
      numFields <- append(numFields, nm)
    }
  }

  dfr <- data.frame(Var1 = as.character(), Var2 = as.character(), cramersV_score = as.numeric())
  for(i in 1:length(numFields)){
    for(j in 1:length(numFields)){
      if(i >= j){
        Var1 = numFields[i]
        Var2 = numFields[j]

        cor.val <- cor(dat[,numFields[i]], dat[,numFields[j]], use = "complete.obs")

        dfr <- rbind(dfr, data.frame(Var1 = Var1, Var2 = Var2, correlation = cor.val))
      }
    }
  }

  # Return the raw data if output = 'raw'
  if(output == 'raw'){
    return(dfr %>% filter(Var1 != Var2))
  }

  if(output == 'plot'){
    # Recreating the values for each pair of variables
    dfr <- rbind(dfr, data.frame(Var1 = dfr$Var2, Var2 = dfr$Var1, correlation = dfr$correlation))

    # Reordering
    dfr$Var2 <- factor(dfr$Var2, levels = levels(dfr$Var1))

    # Tile Plot
    dfr %>%
      rowwise() %>%
      mutate(valLabel = ifelse(val.label,correlation,NA)) %>%
      ggplot(aes(x=Var1,y=Var2,fill=correlation))+
      geom_tile()+
      scale_fill_gradientn(name = "Correlation Coefficient",
                           colors = c("firebrick2", "white", "chartreuse2"),
                           limits = c(-1.0, 1.0),
                           breaks = c(-1.0, 0.0, 1.0),
                           labels = c("-1.0", "0.0", "1.0"))+
      geom_text(aes(x = Var1, y = Var2, label = round(valLabel,2)))+
      scale_x_discrete(name = "")+
      scale_y_discrete(name = "")+
      ggtitle(plotTitle)+
      theme_classic() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  }
}
