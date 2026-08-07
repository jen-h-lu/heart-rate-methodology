# ============================================================
# Generalized Additive Model
# physioSim Benchmarking Study
# ============================================================

fit_gam <- function(data) {
  
  # Make sure condition is a factor
  data$condition <- factor(data$condition)
  
  # Create a numeric indicator for treatment
  data$treatment <- ifelse(
    data$condition == "treatment",
    1,
    0
  )
  
  model <- mgcv::gam(
    observed_hr ~
      condition +
      s(time, k = 10) +
      s(time, by = treatment, k = 10) +
      s(subject, bs = "re"),
    data = data,
    method = "REML"
  )
  
  return(model)
}