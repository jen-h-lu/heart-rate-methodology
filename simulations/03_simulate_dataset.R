library(tidyverse)

source("R/generate_subjects.R")
source("R/generate_response_curve.R")
source("R/simulate_dataset.R")

sim_data <- simulate_dataset(
  n_subjects = 20,
  response = "immediate",
  seed = 123
)

glimpse(sim_data)

ggplot(
  sim_data,
  aes(time, observed_hr,
      group = subject)
) +
  geom_line(alpha = 0.4) +
  labs(
    title = "Simulated Heart-Rate Trajectories",
    x = "Time (seconds)",
    y = "Observed Heart Rate (bpm)"
  )