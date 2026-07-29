# Generate physiological response curves
#
# Generates the expected heart-rate response over time for a given
# response type.

generate_response_curve <- function(
    time,
    response = "null",
    amplitude = 12,
    peak_time = 60
) {
  
  if (response == "null") {
    
    curve <- rep(0, length(time))
    
  } else if (response == "immediate") {
    
    curve <- amplitude *
      exp(-(time - peak_time)^2 / (2 * 20^2))
    
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