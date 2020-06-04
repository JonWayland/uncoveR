#' expose
#'
#' @param dat Dataframe object
#' @param target Name of column from datafame for uncovering insights. Must be a string.
#' @param n.levels Specified number of levels to treat a factor variable (default is six)
#'
#' @return Insights report based on input target
#' @export
#'
#' @examples
#' hp <- read.csv('https://raw.githubusercontent.com/JonWayland/Fake-Healthcare/master/HP-Universal_DF.csv)
#' expose(hp, target = "HP_Paid")
expose <- function(dat, target = NA, n.levels = 6){

  if(!is.data.frame(dat)){stop(paste0('Object `',deparse(substitute(dat)),'` is not a dataframe! Please input a dataframe and choose a target.'))}
  if(is.na(target)){stop(paste0('Please select a variable from ',deparse(substitute(dat)),' as your `target`. No default assumed.'))}

  # Set the target to object `label`
  label <- dat[target][,1]

  # Convert target to factor if numeric and less than n.levels unique values
  unique_vals <- length(unique(dat[target][,1]))
  if(unique_vals < n.levels){
    label <- as.factor(label)
  }

  # Convert integer targets to numeric
  if(class(label) == 'integer'){
    label <- as.numeric(label)
    warning('Target of class integer converted to class numeric.')
  }

  # Stopping if not a supported datatype
  if(!class(label) %in% c('factor', 'numeric')){stop(paste0('Selected target (',target,') is not supported a datatype. Check class(',deparse(substitute(dat)),'$',target,') to see what datatype your target is.'))}

  # Determining categorical fields
  catFields <- c()
  for(nm in names(dat)){
    if(length(levels(factor(dat[nm][,1]))) <= n.levels & length(levels(factor(dat[nm][,1]))) > 1){
      catFields <- append(catFields, nm)
    }
  }
  dfr_cat <- data.frame(Var1 = as.character(), Var2 = as.character(), cramersV_score = as.numeric())

  # Determining numeric fields
  numFields <- c()
  for(nm in names(dat)){
    if(is.numeric(dat[nm][,1])){
      numFields <- append(numFields, nm)
    }
  }
  dfr_num <- data.frame(Var1 = as.character(), Var2 = as.character(), cramersV_score = as.numeric())

  ##########################
  ### For numeric target ###
  ##########################
  if(class(label) == 'numeric'){
    # Find all linear relationships
    for(i in 1:length(numFields)){
      for(j in 1:length(numFields)){
        if(i >= j){
          Var1 = numFields[i]
          Var2 = numFields[j]

          cor.val <- cor(dat[,numFields[i]], dat[,numFields[j]], use = "complete.obs")

          dfr_num <- rbind(dfr_num, data.frame(Var1 = Var1, Var2 = Var2, correlation = cor.val))
        }
      }
    }
    # Removing the diagonal
    dfr_num <- subset(dfr_num, Var1 != Var2)
    # Arrange by highest correlations
    mod_to_high_cor <- subset(dfr_num[order(-dfr_num$correlation),], correlation >= 0.3 & (Var1 == target | Var2 == target))

    # Identifying the non-target (must be class character)
    mod_to_high_cor$Var1 <- as.character(mod_to_high_cor$Var1)
    mod_to_high_cor$Var2 <- as.character(mod_to_high_cor$Var2)
    mod_to_high_cor$NonTarget <- ifelse(mod_to_high_cor$Var1 == target, mod_to_high_cor$Var2, mod_to_high_cor$Var1)
    # Restructuring for ouput
    mod_to_high_cor <- data.frame(Variable = mod_to_high_cor$NonTarget, Correlation = mod_to_high_cor$correlation)

    # Beginning the output
    output <- paste0("\nExposing insights on ", target, " in the ",deparse(substitute(dat))," dataset..\n\n")


    output <- paste0(output, paste0("\nModerate-to-High Correlations with Target: \n",
                                               paste0(capture.output(mod_to_high_cor),
                                                      collapse = "\n")), "\n\n")

    #############################
    ### Testing linear models ###
    #############################

    # Addressing multi-collinearity
    multicol <- subset(dfr_num, correlation >= 0.5 & (Var1 != target & Var2 != target))
    if(nrow(multicol) > 0){
      output <- paste0(output, paste0("\nMulti-Collinearity Found: \n",
                                                 paste0(capture.output(multicol),
                                                        collapse = "\n")), "\n\n")
      # Identifying the unique variables
      mc_unique_vars <- unique(c(as.character(multicol$Var1), as.character(multicol$Var2)))

      # Running PCA on these variables
      mc_dat <- dat[, mc_unique_vars]

      pca <- prcomp(mc_dat, scale = TRUE)
      eigs <- pca$sdev^2
      cumvar <- cumsum(eigs)/sum(eigs)

      # Setting the first percent diff from previous as .99 as to never be used unless it explains at least 80%
      diff_from_prev <- c(0.99)

      # Calculating the percent difference from the previous principal component
      for(i in 1:length(cumvar)){diff_from_prev <- append(diff_from_prev,((cumvar[i+1] - cumvar[i] )/ cumvar[i]))}

      diff_from_prev <- diff_from_prev[-length(diff_from_prev)]
      pca_pick <- data.frame(cumvar = cumvar, diff_from_prev = diff_from_prev)
      # Number of principal components - when percent difference in cumulative percent explained gets below 5% OR greater than 80% is explained
      pca_pick$pick <- ifelse(pca_pick$diff_from_prev < 0.05 | cumvar >= 0.8, 1, 0)
      # force the final row to be 1
      pca_pick$pick[nrow(pca)] <- 1

      # Picking the number of principal components
      pca_pick <- subset(pca_pick, pick == 1)
      num_components <- rownames(pca_pick)[1]

      output <- paste0(output, paste0("\n\nDue to multicollinearity being present, principal component analysis was constructed on the following ",
                                                 prettyNum(length(mc_unique_vars), ','), " variables: ", paste0(mc_unique_vars, collapse = ", "),"..\n\n",
                                                 "A total of ",num_components," principal components are used for the linear model. \n",num_components,
                                                 " was chosen using % difference from previous component being less than 5% OR greater than 80% of total variance explained."))


    }

    # Applying the principal components to the model
    data_for_lm <- dat
    data_for_lm <- data_for_lm[,!(names(data_for_lm) %in% mc_unique_vars)]
    pred <- data.frame(predict(pca, newdata = dat))

    # Subsetting for the number of components to be used
    if(num_components == 1){
      pred <- data.frame(PC1 = pred[,1])
    }
    else {
      pred <- pred[,1:num_components]
    }

    # Adding the components in
    data_for_lm <- cbind(data_for_lm,pred)

    # Removing the target from the predictor set
    data_for_lm <- data_for_lm[,!(names(data_for_lm) %in% target)]

    # Removing any other problematic variables w/ at least 500 levels
    charFields <- c()
    for(nm in names(dat)){
      if(!class(dat[nm][,1]) %in% c('integer', 'numeric', 'integer64', 'double')){
        if(length(levels(factor(dat[nm][,1]))) >= 500){
          charFields <- append(charFields, nm)
        }
      }
    }
    data_for_lm <- data_for_lm[,!(names(data_for_lm) %in% charFields)]

    # Fitting the linear model
    fit <- lm(label ~ ., data = data_for_lm)

    # Determining significant variables only
    sumfit_coef <- summary(fit)$coefficients
    sigVars <- rownames(sumfit_coef[ifelse(sumfit_coef[,4] < 0.05, TRUE, FALSE),])
    sigVars <- sigVars[sigVars != '(Intercept)']
    # Removing any variables that doesn't match the pattern of an original variable (i.e. factor variables)
    trouble_var_list <- c()
    fixed_var_list <- c()
    for(i in 1:length(sigVars)){
      if(!sigVars[i] %in% names(dat)){
        # First, check if the variable is a principal component. If so, then do nothing
        if(substr(sigVars[i],1,2) != 'PC'){
          # If it isn't in the original variable list then remove parts of the string on the right side until it is
          trouble_var <- sigVars[i]
          trouble_var_list <- append(trouble_var_list, trouble_var)

          fixed_var <- trouble_var
          for(j in 1:nchar(trouble_var)){
            fixed_var <- substr(trouble_var, 1, nchar(trouble_var) - j)
            if(fixed_var %in% names(dat)){fixed_var_list <- append(fixed_var_list, fixed_var)}
          }
        }
      }
    }

    fixed_trouble <- data.frame(`Trouble Variable` = trouble_var_list,
                                `Fixed Version` = fixed_var_list)

    # Updating the output to include these fixes
    if(length(fixed_var_list) > 0){
      output <- paste0(output, paste0("\n\nThe following significant variables were cleaned up to fit the final model:\n\n",
                                                 paste0(capture.output(fixed_trouble),
                                                        collapse = "\n")))
    }

    # Remove trouble and add fixed
    sigVars <- sigVars[!sigVars %in% trouble_var_list]
    sigVars <- append(sigVars, fixed_var_list)

    # Re-fitting with just significant variables
    lm.formula <- as.formula(paste0("label ~ ", paste0(sigVars, collapse = "+")))

    # New model
    fit <- lm(lm.formula, data = data_for_lm)

    # Summarizing what this model tells us
    sumfit <- summary(fit)
    sumfit_coef <- sumfit$coefficients

    # Output update with model insights
    output <- paste0(output, paste0("\n\nThe following linear model explains ",round(100*sumfit$r.squared,2), "% of the variance in ", target," (Adjusted R-Squared = ", round(100*sumfit$adj.r.squared,2),"%)"))

    output <- paste0(output,"\n\n", paste0(capture.output(sumfit_coef),
                                                      collapse = "\n"))


    # End expose
  }

  #########################
  ### For factor target ###
  #########################
  if(class(label) == 'factor'){
    output <- "Target class is factor. Exposing factor variables is currently under development. Sorry for any inconvenience."
    # End expose
  }

  return(writeLines(output))
}
