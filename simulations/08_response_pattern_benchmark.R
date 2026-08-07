# ============================================================
# physioSim 2
#
# Experiment 1:
# Method performance across response patterns
#
# ============================================================


library(tidyverse)
library(lme4)
library(lmerTest)


# ------------------------------------------------------------
# Load functions
# ------------------------------------------------------------

source("R/generate_response_curve.R")
source("R/generate_ar_noise.R")
source("R/simulate_dataset.R")

source("R/fit_summary_model.R")
source("R/fit_lmm.R")
source("R/benchmark_metrics.R")



# ------------------------------------------------------------
# Simulation settings
# ------------------------------------------------------------


TRUE_EFFECTS <- tibble(
  
  response = c(
    "null",
    "immediate",
    "delayed",
    "sustained",
    "habituation"
  ),
  
  true_effect = c(
    0,
    3,
    3,
    3,
    3
  )
  
)


RHO <- 0.6

REPLICATES <- 50

SAMPLE_SIZE <- 80


RESPONSE_TYPES <- c(
  "null",
  "immediate",
  "delayed",
  "sustained",
  "habituation"
)



# ------------------------------------------------------------
# Run one simulation
# ------------------------------------------------------------


run_one_response_sim <- function(
    response_type,
    replicate_id
){
  
  
  # Get true effect for this response pattern
  
  true_effect <- TRUE_EFFECTS %>%
    filter(response == response_type) %>%
    pull(true_effect)
  
  
  
  # Generate simulated data
  
  data <- simulate_dataset(
    
    n_subjects = SAMPLE_SIZE,
    response = response_type,
    amplitude = true_effect,
    rho = RHO
    
  )
  
  
  
  
  # ----------------------------------------------------------
  # Summary statistic model
  # ----------------------------------------------------------
  
  
  summary_model <- fit_summary_model(data)
  
  
  summary_results <-
    
    extract_lmm_results(
      
      summary_model,
      true_effect = true_effect
      
    ) %>%
    
    mutate(
      method = "Summary"
    )
  
  
  
  
  # ----------------------------------------------------------
  # Full trajectory LMM
  # ----------------------------------------------------------
  
  
  lmm_model <- fit_lmm(data)
  
  
  lmm_results <-
    
    extract_lmm_results(
      
      lmm_model,
      true_effect = true_effect
      
    ) %>%
    
    mutate(
      method = "LMM"
    )
  
  
  
  
  # Combine results
  
  bind_rows(
    summary_results,
    lmm_results
  ) %>%
    
    mutate(
      
      response = response_type,
      replicate = replicate_id
      
    )
  
}





# ------------------------------------------------------------
# Run simulations
# ------------------------------------------------------------


results <- expand_grid(
  
  response = RESPONSE_TYPES,
  
  replicate = 1:REPLICATES
  
) %>%
  
  pmap_dfr(
    run_one_response_sim
  )





# ------------------------------------------------------------
# Summarize results
# ------------------------------------------------------------


summary_results <- results %>%
  
  group_by(
    response,
    method
  ) %>%
  
  summarise(
    
    
    estimate =
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
          
          bias^2,
          
          na.rm = TRUE
          
        )
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
# Output
# ------------------------------------------------------------


print(summary_results)


write_csv(
  
  summary_results,
  
  "results/response_pattern_comparison.csv"
  
)