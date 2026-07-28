#' Generate simulated study participants
#'
#' Creates a study population with realistic baseline heart rates and
#' subject-level random effects.
#'
#' @param n Number of participants.
#' @param baseline_mean Mean resting heart rate (bpm).
#' @param baseline_sd Standard deviation of resting heart rate.
#' @param subject_sd Standard deviation of subject random effects.
#' @param seed Optional random seed for reproducibility.
#'
#' @return A tibble with one row per participant.
#'
#' @export

generate_subjects <- function(
    n = 80,
    baseline_mean = 72,
    baseline_sd = 6,
    subject_sd = 3,
    seed = NULL
) {
  
  if (!is.null(seed)) {
    set.seed(seed)
  }
  
  participants <- tibble::tibble(
    subject = seq_len(n),
    
    baseline_hr = rnorm(
      n,
      mean = baseline_mean,
      sd = baseline_sd
    ),
    
    random_effect = rnorm(
      n,
      mean = 0,
      sd = subject_sd
    )
  )
  
  participants
  
}