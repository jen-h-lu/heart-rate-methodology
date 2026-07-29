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