library(tidyverse)


source("../R/simulate_dataset.R")
source("../R/add_condition.R")
source("../R/fit_models.R")


sample_sizes <- c(
  20,
  40,
  80,
  160
)


power_results <- map_dfr(
  
  sample_sizes,
  
  function(n){
    
    
    p_values <- replicate(
      
      500,
      
      {
        
        
        data <- simulate_dataset(
          n_subjects = n,
          response = "immediate"
        )
        
        
        data <- add_condition(data)
        
        
        model_result <- fit_lmm(data)
        
        
        model_result["Pr(>|t|)"]
        
      }
      
    )
    
    
    tibble(
      
      sample_size = n,
      
      power = mean(
        p_values < 0.05
      )
      
    )
    
  }
  
)


write_csv(
  power_results,
  "results/power_results.csv"
)


power_results