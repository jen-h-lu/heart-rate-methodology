# ============================================================
# Summary-Statistic Model
# physioSim Benchmarking Study
# ============================================================

fit_summary_model <- function(data) {
  
  # Calculate participant-level mean response
  summary_data <- data %>%
    dplyr::group_by(subject, condition) %>%
    dplyr::summarise(
      mean_hr = mean(observed_hr, na.rm = TRUE),
      .groups = "drop"
    )
  
  # Fit mixed-effects model using lmerTest
  model <- lmerTest::lmer(
    mean_hr ~ condition + (1 | subject),
    data = summary_data,
    REML = TRUE
  )
  
  return(model)
}