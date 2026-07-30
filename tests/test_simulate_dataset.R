library(testthat)
library(physioSim)


test_that("simulate_dataset returns correct dimensions", {
  
  sim_data <- simulate_dataset(
    n_subjects = 5,
    seed = 1
  )
  
  expect_equal(
    nrow(sim_data),
    5 * length(unique(sim_data$time))
  )
  
})


test_that("simulate_dataset contains unique subjects", {
  
  sim_data <- simulate_dataset(
    n_subjects = 5,
    seed = 1
  )
  
  expect_equal(
    length(unique(sim_data$subject)),
    5
  )
  
})


test_that("simulate_dataset contains required columns", {
  
  sim_data <- simulate_dataset(
    n_subjects = 5,
    seed = 1
  )
  
  expect_true(
    all(c(
      "subject",
      "time",
      "baseline_hr",
      "random_effect",
      "response",
      "observed_hr"
    ) %in% names(sim_data))
  )
  
})