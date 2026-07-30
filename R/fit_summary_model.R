#' Fit summary-statistic model
#'
#' @param data Dataset.
#'
#' @return P-value.
#'
#' @export
fit_summary_model <- function(data){
  
  
  summary_data <- data %>%
    group_by(subject, condition) %>%
    summarize(
      
      mean_hr = mean(
        observed_hr,
        na.rm = TRUE
      ),
      
      .groups = "drop"
    )
  
  
  # Convert to wide format
  summary_wide <- summary_data %>%
    pivot_wider(
      names_from = condition,
      values_from = mean_hr
    )
  
  
  # Calculate change score
  summary_wide <- summary_wide %>%
    mutate(
      delta_hr = `1` - `0`
    )
  
  
  # Test whether change differs from zero
  model <- lm(
    delta_hr ~ 1,
    data = summary_wide
  )
  
  
  summary(model)$coefficients[
    "(Intercept)",
    "Pr(>|t|)"
  ]
  
}