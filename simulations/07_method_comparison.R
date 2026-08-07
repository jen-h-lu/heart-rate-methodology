# ============================================================
# physioSim Method Comparison
#
# Compares:
#   1. Summary-statistic model
#   2. Linear mixed-effects model
#
# Metrics:
#   - Effect estimate
#   - Bias
#   - RMSE
#   - Power
#   - Confidence interval coverage
#
# ============================================================


# ------------------------------------------------------------
# 1. Load packages
# ------------------------------------------------------------

library(tidyverse)
library(lme4)
library(lmerTest)


# ------------------------------------------------------------
# 2. Load physioSim functions
# ------------------------------------------------------------

source("R/generate_subjects.R")
source("R/generate_ar_noise.R")
source("R/generate_response_curve.R")
source("R/simulate_dataset.R")

source("R/fit_summary_model.R")
source("R/fit_lmm.R")
source("R/benchmark_metrics.R")


# ------------------------------------------------------------
# 3. Simulation settings
# ------------------------------------------------------------

TRUE_EFFECT <- 3

RHO <- 0.6

REPLICATES <- 200

SAMPLE_SIZES <- c(
  20,
  40,
  80,
  160
)


# ------------------------------------------------------------
# 4. Function to run ONE simulation
# ------------------------------------------------------------

run_one_simulation <- function(
    sample_size,
    replicate_id
) {
  
  # Generate dataset
  data <- simulate_dataset(
    n_subjects = sample_size,
    response = "immediate",
    amplitude = TRUE_EFFECT,
    rho = RHO
  )
  
  
  # ----------------------------------------------------------
  # Summary-statistic model
  # ----------------------------------------------------------
  
  summary_model <- fit_summary_model(data)
  
  summary_results <- extract_lmm_results(
    summary_model,
    true_effect = TRUE_EFFECT
  )
  
  
  # ----------------------------------------------------------
  # Linear mixed-effects model
  # ----------------------------------------------------------
  
  lmm_model <- fit_lmm(data)
  
  lmm_results <- extract_lmm_results(
    lmm_model,
    true_effect = TRUE_EFFECT
  )
  
  
  # ----------------------------------------------------------
  # Return results
  # ----------------------------------------------------------
  
  bind_rows(
    
    summary_results %>%
      mutate(
        method = "Summary",
        sample_size = sample_size,
        replicate = replicate_id
      ),
    
    lmm_results %>%
      mutate(
        method = "LMM",
        sample_size = sample_size,
        replicate = replicate_id
      )
    
  )
  
}


# ------------------------------------------------------------
# 5. Create simulation grid
# ------------------------------------------------------------

simulation_grid <- expand_grid(
  
  sample_size = SAMPLE_SIZES,
  
  replicate = 1:REPLICATES
  
)


# ------------------------------------------------------------
# 6. Run simulations
# ------------------------------------------------------------

benchmark_results <- purrr::map2_dfr(
  
  simulation_grid$sample_size,
  
  simulation_grid$replicate,
  
  run_one_simulation
  
)


# ------------------------------------------------------------
# 7. Inspect raw results
# ------------------------------------------------------------

print(benchmark_results)


# ------------------------------------------------------------
# 8. Summarize performance
# ------------------------------------------------------------

benchmark_summary <- benchmark_results %>%
  
  group_by(
    method,
    sample_size
  ) %>%
  
  summarise(
    
    mean_estimate =
      mean(
        estimate,
        na.rm = TRUE
      ),
    
    bias =
      mean(
        bias,
        na.rm = TRUE
      ),
    
    RMSE =
      sqrt(
        mean(
          (estimate - TRUE_EFFECT)^2,
          na.rm = TRUE
        )
      ),
    
    SD =
      sd(
        estimate,
        na.rm = TRUE
      ),
    
    power =
      mean(
        p_value < 0.05,
        na.rm = TRUE
      ),
    
    coverage =
      mean(
        covered,
        na.rm = TRUE
      ),
    
    .groups = "drop"
    
  )


# ------------------------------------------------------------
# 9. Print summary
# ------------------------------------------------------------

print(benchmark_summary)


# ------------------------------------------------------------
# 10. Save results
# ------------------------------------------------------------

write_csv(
  benchmark_results,
  "results/method_comparison_raw.csv"
)

write_csv(
  benchmark_summary,
  "results/method_comparison_summary.csv"
)