#' Fit Linear Mixed Effects Model
#'
#' Fits a linear mixed-effects model to simulated physiological
#' time-series data.
#'
#' @param data A data frame containing simulated physiological measurements.
#'
#' @return A model summary containing estimated effects and statistical tests.
#'
#' @importFrom lmerTest lmer
#'
#' @export
#'
#' @examples
#' \dontrun{
#' data <- simulate_dataset(
#'   n_subjects = 20,
#'   response = "immediate"
#' )
#'
#' data <- add_condition(data)
#'
#' fit_lmm(data)
#' }


fit_lmm <- function(data){
  
  lme4::lmer(
    observed_hr ~ condition * time + (1 | subject),
    data = data
  )
  
}