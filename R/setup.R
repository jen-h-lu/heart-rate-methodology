# Package setup utilities
#
# Checks that required dependencies are available.

.check_dependencies <- function() {
  
  required_packages <- c(
    "tidyverse",
    "lme4",
    "lmerTest",
    "mgcv",
    "fda",
    "purrr"
  )
  
  missing_packages <- required_packages[
    !vapply(
      required_packages,
      requireNamespace,
      quietly = TRUE,
      FUN.VALUE = logical(1)
    )
  ]
  
  if(length(missing_packages) > 0) {
    warning(
      paste(
        "Missing required packages:",
        paste(missing_packages, collapse = ", "),
        "\nPlease install them before using physioSim."
      )
    )
  }
  
  invisible(TRUE)
}