library(tidyverse)

source("R/generate_response_curve.R")

time <- seq(0, 300, by = 5)

responses <- tibble(
  time = time,
  Null = generate_response_curve(time, "null"),
  Immediate = generate_response_curve(time, "immediate"),
  Delayed = generate_response_curve(time, "delayed"),
  Sustained = generate_response_curve(time, "sustained"),
  Habituation = generate_response_curve(time, "habituation")
)

responses_long <- tidyr::pivot_longer(
  responses,
  -time,
  names_to = "Response",
  values_to = "HeartRateChange"
)

ggplot(
  responses_long,
  aes(time, HeartRateChange, color = Response)
) +
  geom_line(linewidth = 1) +
  labs(
    title = "Physiological Response Curves",
    x = "Time (seconds)",
    y = "Change in Heart Rate (bpm)"
  )