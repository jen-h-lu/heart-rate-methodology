library(tidyverse)


trajectory_summary <- read_csv(
  "results/trajectory_recovery_summary.csv",
  show_col_types = FALSE
)


figure3 <- ggplot(
  trajectory_summary,
  aes(
    x = response,
    y = mean_RMSE,
    fill = method
  )
) +
  
  geom_col(
    position = position_dodge(width = 0.8),
    width = 0.7
  ) +
  
  geom_errorbar(
    aes(
      ymin = mean_RMSE - SD_RMSE,
      ymax = mean_RMSE + SD_RMSE
    ),
    position = position_dodge(width = 0.8),
    width = 0.2
  ) +
  
  labs(
    title = "Trajectory Recovery Performance",
    subtitle = "Lower RMSE indicates more accurate recovery of simulated physiological responses",
    x = "Response Pattern",
    y = "Trajectory RMSE",
    fill = "Model"
  ) +
  
  theme_classic()


figure3


ggsave(
  "figures/figure3_trajectory_recovery.png",
  figure3,
  width = 7,
  height = 5,
  dpi = 300
)