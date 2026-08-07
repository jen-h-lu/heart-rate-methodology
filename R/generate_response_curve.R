#' Generate Physiological Response Curves
#'
#' Simulates physiological response trajectories representing
#' common experimental response patterns.
#'
#' @param time Numeric vector of time points.
#' @param response Character string specifying response type.
#' @param amplitude Peak response magnitude.
#' @param peak_time Time of peak response.
#'
#' @return Numeric vector of simulated response values.
#'
#' @export

generate_response_curve <- function(
    time,
    response = "null",
    amplitude = 3,
    peak_time = 60
) {
  
  if (response == "null") {
    
    curve <- rep(0, length(time))
    
  } else if (response == "immediate") {
    
    curve <- ifelse(
      time >= 10,
      amplitude,
      0
    )
    
  } else if (response == "delayed") {
    
    curve <- amplitude /
      (1 + exp(-(time - peak_time) / 12))
    
  } else if (response == "sustained") {
    
    curve <- amplitude *
      (1 - exp(-time / 25))
    
  } else if (response == "habituation") {
    
    curve <- amplitude *
      exp(-time / 90)
    
  } else {
    
    stop("Unknown response type.")
    
  }
  
  curve
  
}