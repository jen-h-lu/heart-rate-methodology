# ============================================================
# Benchmark Metrics
# physioSim Benchmarking Study
# ============================================================


# ------------------------------------------------------------
# Extract results from a mixed-effects model
# ------------------------------------------------------------

extract_lmm_results <- function(model, true_effect = 3) {
  
  coef_table <- summary(model)$coefficients
  
  # Make sure the treatment coefficient exists
  if (!"conditiontreatment" %in% rownames(coef_table)) {
    
    return(
      tibble::tibble(
        estimate = NA_real_,
        standard_error = NA_real_,
        p_value = NA_real_,
        lower = NA_real_,
        upper = NA_real_,
        bias = NA_real_,
        covered = NA
      )
    )
    
  }
  
  # Extract estimate
  estimate <- coef_table[
    "conditiontreatment",
    "Estimate"
  ]
  
  # Extract standard error
  standard_error <- coef_table[
    "conditiontreatment",
    "Std. Error"
  ]
  
  # Extract p-value
  p_value <- coef_table[
    "conditiontreatment",
    "Pr(>|t|)"
  ]
  
  # Calculate 95% confidence interval
  ci <- confint(
    model,
    parm = "conditiontreatment",
    level = 0.95
  )
  
  lower <- ci[1]
  upper <- ci[2]
  
  # Calculate bias
  bias <- estimate - true_effect
  
  # Determine whether CI contains true effect
  covered <- (
    lower <= true_effect &&
      upper >= true_effect
  )
  
  tibble::tibble(
    estimate = estimate,
    standard_error = standard_error,
    p_value = p_value,
    lower = lower,
    upper = upper,
    bias = bias,
    covered = covered
  )
}