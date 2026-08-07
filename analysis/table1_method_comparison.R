library(tidyverse)


results <- read_csv(
  "results/response_pattern_comparison.csv"
)


table1 <- results %>%
  
  select(
    response,
    method,
    estimate,
    bias,
    RMSE,
    power,
    coverage
  )


print(
  table1,
  width = Inf
)


write_csv(
  table1,
  "results/table1_method_comparison.csv"
)