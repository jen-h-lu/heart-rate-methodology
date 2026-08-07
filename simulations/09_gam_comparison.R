# ============================================================
# physioSim 2
#
# Experiment 2:
# Comparing Summary, LMM, and GAMM for dynamic responses
#
# ============================================================


library(tidyverse)
library(lme4)
library(lmerTest)
library(mgcv)


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


TRUE_EFFECT <- 3

RHO <- 0.6

REPLICATES <- 50

SAMPLE_SIZE <- 80


RESPONSE_TYPES <- c(
  "immediate",
  "delayed",
  "sustained",
  "habituation"
)



# ------------------------------------------------------------
# Fit GAMM
# ------------------------------------------------------------


fit_gamm <- function(data){
  
  
  # Create binary treatment indicator
  # Needed for by smooth
  
  data <- data %>%
    mutate(
      treatment_numeric =
        ifelse(
          condition == "treatment",
          1,
          0
        )
    )
  
  
  
  gam(
    
    observed_hr ~
      
      condition +
      s(time, k = 10) +
      s(time, by = treatment_numeric, k = 10) +
      s(subject, bs = "re"),
    
    data = data,
    
    method = "REML"
    
  )
  
}





# ------------------------------------------------------------
# Extract GAM results
# ------------------------------------------------------------


extract_gam_results <- function(
    model,
    true_effect
){
  
  
  coef_table <- summary(model)$p.table
  
  
  # condition effect
  
  estimate <-
    coef_table[
      "conditiontreatment",
      "Estimate"
    ]
  
  
  p_value <-
    coef_table[
      "conditiontreatment",
      "Pr(>|t|)"
    ]
  
  
  
  tibble(
    
    estimate = estimate,
    
    standard_error =
      coef_table[
        "conditiontreatment",
        "Std. Error"
      ],
    
    p_value = p_value,
    
    bias =
      estimate - true_effect,
    
    lower =
      estimate -
      1.96 *
      coef_table[
        "conditiontreatment",
        "Std. Error"
      ],
    
    upper =
      estimate +
      1.96 *
      coef_table[
        "conditiontreatment",
        "Std. Error"
      ],
    
    covered =
      lower <= true_effect &
      upper >= true_effect
    
  )
  
}





# ------------------------------------------------------------
# One simulation
# ------------------------------------------------------------


run_one_gam_sim <- function(
    response_type,
    replicate_id
){
  
  
  data <- simulate_dataset(
    
    n_subjects = SAMPLE_SIZE,
    
    response = response_type,
    
    amplitude = TRUE_EFFECT,
    
    rho = RHO
    
  )
  
  
  
  # -------------------------
  # Summary model
  # -------------------------
  
  
  summary_model <-
    fit_summary_model(data)
  
  
  summary_results <-
    
    extract_lmm_results(
      summary_model,
      true_effect = TRUE_EFFECT
    ) %>%
    
    mutate(
      method = "Summary"
    )
  
  
  
  
  # -------------------------
  # LMM
  # -------------------------
  
  
  lmm_model <-
    fit_lmm(data)
  
  
  lmm_results <-
    
    extract_lmm_results(
      lmm_model,
      true_effect = TRUE_EFFECT
    ) %>%
    
    mutate(
      method = "LMM"
    )
  
  
  
  
  # -------------------------
  # GAMM
  # -------------------------
  
  
  gam_model <-
    fit_gamm(data)
  
  
  gam_results <-
    
    extract_gam_results(
      gam_model,
      true_effect = TRUE_EFFECT
    ) %>%
    
    mutate(
      method = "GAMM"
    )
  
  
  
  
  bind_rows(
    summary_results,
    lmm_results,
    gam_results
  ) %>%
    
    mutate(
      
      response = response_type,
      replicate = replicate_id
      
    )
  
}





# ------------------------------------------------------------
# Run simulation
# ------------------------------------------------------------


results <- expand_grid(
  
  response = RESPONSE_TYPES,
  
  replicate = 1:REPLICATES
  
) %>%
  
  pmap_dfr(
    run_one_gam_sim
  )





# ------------------------------------------------------------
# Summarize
# ------------------------------------------------------------


gam_summary <- results %>%
  
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


print(
  gam_summary
)


write_csv(
  
  gam_summary,
  
  "results/gam_method_comparison.csv"
  
)