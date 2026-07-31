library(physioSim)
library(tidyverse)
library(lme4)
library(lmerTest)
library(mgcv)


set.seed(123)


methods <- c(
  "Summary Model",
  "Linear Mixed Model",
  "GAM"
)


response_types <- c(
  "null",
  "immediate",
  "delayed",
  "habituation",
  "sustained"
)


results <- expand_grid(
  method = methods,
  response = response_types
) %>%
  mutate(power = NA)


for(i in 1:nrow(results)){
  
  method <- results$method[i]
  response_type <- results$response[i]
  
  
  successes <- 0
  
  
  for(rep in 1:200){
    
    # Generate simulated physiological data
    data <- simulate_dataset(
      n_subjects = 80,
      response = response_type,
      amplitude = 3,
      rho = 0.6,
      seed = rep
    )
    
    
    # Add experimental condition
    data <- add_condition(data)
    
    
    p <- NA
    
    
    # -----------------------------
    # Summary Statistic Model
    # -----------------------------
    
    if(method == "Summary Model"){
      
      summary_data <- data %>%
        group_by(subject, condition) %>%
        summarise(
          mean_response = mean(observed_hr),
          .groups = "drop"
        )
      
      
      fit <- lm(
        mean_response ~ condition,
        data = summary_data
      )
      
      
      p <- summary(fit)$coefficients["condition",4]
      
    }
    
    
    # -----------------------------
    # Linear Mixed Model
    # -----------------------------
    
    if(method == "Linear Mixed Model"){
      
      fit <- lmer(
        observed_hr ~ condition + time +
          (1|subject),
        data = data
      )
      
      
      p <- summary(fit)$coefficients["condition", "Pr(>|t|)"]
      
    }
    
    
    # -----------------------------
    # Generalized Additive Model
    # -----------------------------
    
    if(method == "GAM"){
      
      fit <- gam(
        observed_hr ~ condition + s(time),
        data = data
      )
      
      
      p <- summary(fit)$p.table["condition",4]
      
    }
    
    
    # Count significant detections
    
    if(length(p) == 1 &&
       !is.na(p) &&
       p < 0.05){
      
      successes <- successes + 1
      
    }
    
    
  }
  
  
  results$power[i] <- successes / 200
  
}



# Save results

write_csv(
  results,
  "results/method_benchmark_results.csv"
)


print(results)