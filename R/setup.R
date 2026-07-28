# Project setup ------------------------------------------------------------

required_packages <- c(
  "tidyverse",
  "here",
  "renv",
  "targets",
  "tarchetypes",
  "lme4",
  "mgcv",
  "fda",
  "brms",
  "future",
  "furrr",
  "patchwork",
  "gt",
  "devtools",
  "usethis",
  "testthat"
)

missing_packages <- required_packages[
  !required_packages %in% installed.packages()[, "Package"]
]

if (length(missing_packages) > 0) {
  install.packages(missing_packages)
} else {
  message("All required packages are already installed.")
}