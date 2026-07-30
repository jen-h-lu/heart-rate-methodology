#' Create simulation scenarios
#'
#' Generates combinations of simulation settings.
#'
#' @export

create_scenarios <- function() {
  
  expand.grid(
    
    n_subjects = c(20, 40, 80, 160),
    
    noise = c("low", "medium", "high"),
    
    missing = c(0, 0.10, 0.20, 0.40),
    
    autocorrelation = c(0.3, 0.6, 0.9),
    
    response = c(
      "null",
      "immediate",
      "delayed",
      "habituation",
      "sustained"
    ),
    
    KEEP.OUT.ATTRS = FALSE
    
  )
  
}