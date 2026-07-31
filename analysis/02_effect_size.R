library(tidyverse)
library(lme4)
library(broom.mixed)
library(here)

source("R/simulate_dataset.R")
source("R/fit_models.R")

set.seed(123)

effect_sizes <- c(
  0.5,
  1,
  2,
  3,
  5
)


sample_sizes <- c(
  40,
  80,
  160
)


results <- expand_grid(
  effect = effect_sizes,
  n = sample_sizes
)


simulate_power <- function(effect, n){
  
  sig <- replicate(
    200,
    {
      
      data <- simulate_dataset(
        n_subjects = n,
        amplitude = effect,
        response = "immediate",
        rho = 0.6
      )
      
      
      model <- fit_lme(data)
      
      
      summary(model)$coefficients[
        "Condition",
        "Pr(>|t|)"
      ] < .05
      
    }
  )
  
  mean(sig)
  
}

results <- results %>%
  mutate(
    power = map2_dbl(
      effect,
      n,
      simulate_power
    )
  )


write.csv(
  results,
  "results/effect_size_power.csv",
  row.names = FALSE
)


ggplot(
  results,
  aes(
    x = effect,
    y = power,
    color = factor(n)
  )
)+
  geom_line()+
  geom_point()+
  theme_classic()+
  labs(
    x="Effect size (beats/min)",
    y="Statistical power",
    color="Sample size"
  )


ggsave(
  "figures/figure3_effect_size.png",
  width=7,
  height=5
)