#' Fit linear mixed model
#'
#' Fits an LMM to simulated data.
#'
#' @param data Dataset.
#'
#' @return Model statistics.
#'
#' @export
library(lme4)
library(lmerTest)


fit_lmm <- function(data){
  
  model <- lmer(
    observed_hr ~ condition + time +
      (1 | subject),
    data = data
  )
  
  
  results <- summary(model)$coefficients
  
  
  return(
    results["condition",]
  )
  
}