library(tidyverse)

source("R/generate_subjects.R")
source("R/generate_response_curve.R")
source("R/simulate_dataset.R")


# -----------------------------
# Figure 1: Response examples
# -----------------------------

set.seed(123)

responses <- c(
  "null",
  "immediate",
  "delayed",
  "habituation",
  "sustained"
)


figure_data <- map_dfr(
  responses,
  function(resp){
    
    data <- simulate_dataset(
      n_subjects = 5,
      response = resp
    )
    
    data %>%
      mutate(
        response_type = resp
      )
    
  }
)


ggplot(
  figure_data,
  aes(
    x = time,
    y = observed_hr,
    group = subject
  )
) +
  
  geom_line(
    alpha = 0.4
  ) +
  
  facet_wrap(
    ~response_type,
    ncol = 2
  ) +
  
  theme_minimal() +
  
  labs(
    title = "Simulated Physiological Heart-Rate Responses",
    subtitle = "Examples generated using the physioSim framework",
    x = "Time (seconds)",
    y = "Heart Rate (bpm)"
  )


ggsave(
  "figures/01_response_examples.png",
  width = 8,
  height = 6,
  dpi = 300
)