# ============================================================
# Linear Mixed-Effects Model
# physioSim Benchmarking Study
# ============================================================

fit_lmm <- function(data) {
  
  model <- lmerTest::lmer(
    observed_hr ~ condition + time + (1 | subject),
    data = data,
    REML = TRUE
  )
  
  return(model)
}