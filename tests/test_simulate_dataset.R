source("R/generate_subjects.R")
source("R/generate_response_curve.R")
source("R/simulate_dataset.R")

sim_data <- simulate_dataset(
  n_subjects = 5,
  seed = 1
)

stopifnot(nrow(sim_data) == 5 * 61)

stopifnot(length(unique(sim_data$subject)) == 5)

stopifnot(all(c(
  "subject",
  "time",
  "baseline_hr",
  "random_effect",
  "response",
  "observed_hr"
) %in% names(sim_data)))

cat("All tests passed!\n")