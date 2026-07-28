library(tidyverse)

source("R/generate_subjects.R")

subjects <- generate_subjects(
  n = 1000,
  seed = 123
)

ggplot(subjects, aes(baseline_hr)) +
  geom_histogram(
    bins = 30
  ) +
  labs(
    title = "Simulated Baseline Heart Rates",
    x = "Baseline Heart Rate",
    y = "Count"
  )