# ============================================================
# physioSim 2
#
# Experiment 3:
# Trajectory recovery comparison
#
# LMM vs GAMM
#
# ============================================================


library(tidyverse)
library(lme4)
library(mgcv)


# ------------------------------------------------------------
# Load functions
# ------------------------------------------------------------

source("R/generate_subjects.R")
source("R/generate_response_curve.R")
source("R/generate_ar_noise.R")
source("R/simulate_dataset.R")
source("R/fit_lmm.R")



# ------------------------------------------------------------
# Simulation settings
# ------------------------------------------------------------


SAMPLE_SIZE <- 80

TRUE_EFFECT <- 3

RHO <- 0.6

REPLICATES <- 50


RESPONSE_TYPES <- c(
  "immediate",
  "delayed",
  "sustained",
  "habituation"
)



TIME_POINTS <- seq(
  0,
  110,
  by = 10
)



# ------------------------------------------------------------
# Fit GAMM
# ------------------------------------------------------------


fit_gamm <- function(data){
  
  
  data <- data %>%
    mutate(
      condition = factor(condition)
    )
  
  
  gam(
    
    observed_hr ~
      
      condition +
      s(time, by = condition, k = 10) +
      s(subject, bs = "re"),
    
    data = data,
    
    method = "REML"
    
  )
  
}


# ------------------------------------------------------------
# Generate predictions
# ------------------------------------------------------------


predict_lmm_curve <- function(model){
  
  
  prediction_data <- expand_grid(
    
    time = TIME_POINTS,
    
    condition = c(
      "control",
      "treatment"
    )
    
  )
  
  
  prediction_data$subject <- 1
  
  
  prediction_data$predicted <-
    predict(
      model,
      newdata = prediction_data,
      re.form = NA
    )
  
  
  prediction_data
  
}


predict_gamm_curve <- function(model){
  
  
  prediction_data <- expand_grid(
    
    time = TIME_POINTS,
    
    condition = c(
      "control",
      "treatment"
    )
    
  ) %>%
    mutate(
      condition = factor(
        condition,
        levels = c(
          "control",
          "treatment"
        )
      ),
      subject = 1
    )
  
  
  
  prediction_data$predicted <-
    
    predict(
      
      model,
      
      newdata = prediction_data,
      
      exclude = "s(subject)"
      
    )
  
  
  prediction_data
  
}
# ------------------------------------------------------------
# Calculate trajectory error
# ------------------------------------------------------------

calculate_curve_error <- function(
    predictions,
    response_type,
    method
){
  
  
  true_curve <- generate_response_curve(
    
    time = TIME_POINTS,
    
    response = response_type,
    
    amplitude = TRUE_EFFECT,
    
    peak_time = 60
    
  )
  
  
  
  predicted_difference <-
    
    predictions %>%
    
    select(
      time,
      condition,
      predicted
    ) %>%
    
    pivot_wider(
      
      names_from = condition,
      
      values_from = predicted
      
    ) %>%
    
    arrange(time) %>%
    
    mutate(
      
      effect =
        treatment - control
      
    )
  
  
  
  # Ensure same length
  
  if(length(predicted_difference$effect) != length(true_curve)){
    
    stop(
      "Prediction length does not match true curve"
    )
    
  }
  
  
  
  tibble(
    
    response = response_type,
    
    method = method,
    
    
    trajectory_RMSE =
      
      sqrt(
        mean(
          (
            predicted_difference$effect -
              true_curve
          )^2
        )
      ),
    
    
    correlation =
      
      ifelse(
        
        sd(predicted_difference$effect) == 0 |
          sd(true_curve) == 0,
        
        NA,
        
        cor(
          predicted_difference$effect,
          true_curve
        )
        
      )
    
  )
  
}



# ------------------------------------------------------------
# One simulation
# ------------------------------------------------------------


run_one_trajectory_sim <- function(
    response_type,
    replicate_id
){
  
  
  data <- simulate_dataset(
    
    n_subjects = SAMPLE_SIZE,
    
    response = response_type,
    
    amplitude = TRUE_EFFECT,
    
    rho = RHO
    
  )
  
  
  
  # -----------------------------
  # LMM
  # -----------------------------
  
  
  lmm_model <- fit_lmm(data)
  
  
  lmm_predictions <-
    predict_lmm_curve(
      lmm_model
    )
  
  
  lmm_results <-
    
    calculate_curve_error(
      
      lmm_predictions,
      
      response_type,
      
      "LMM"
      
    )
  
  
  
  
  # -----------------------------
  # GAMM
  # -----------------------------
  
  
  gamm_model <-
    fit_gamm(data)
  
  
  gamm_predictions <-
    predict_gamm_curve(
      gamm_model
    )
  
  
  gamm_results <-
    
    calculate_curve_error(
      
      gamm_predictions,
      
      response_type,
      
      "GAMM"
      
    )
  
  
  
  
  bind_rows(
    
    lmm_results,
    
    gamm_results
    
  ) %>%
    
    mutate(
      
      replicate = replicate_id
      
    )
  
}





# ------------------------------------------------------------
# Run simulation
# ------------------------------------------------------------


trajectory_results <- expand_grid(
  
  response = RESPONSE_TYPES,
  
  replicate = 1:REPLICATES
  
) %>%
  
  pmap_dfr(
    run_one_trajectory_sim
  )





# ------------------------------------------------------------
# Summarize trajectory recovery
# ------------------------------------------------------------

trajectory_summary <- trajectory_results %>%
  
  group_by(
    response,
    method
  ) %>%
  
  summarise(
    
    mean_RMSE =
      mean(
        trajectory_RMSE,
        na.rm = TRUE
      ),
    
    SD_RMSE =
      sd(
        trajectory_RMSE,
        na.rm = TRUE
      ),
    
    .groups = "drop"
    
  )


print(
  trajectory_summary,
  width = Inf
)


write_csv(
  trajectory_summary,
  "results/trajectory_recovery_summary.csv"
)