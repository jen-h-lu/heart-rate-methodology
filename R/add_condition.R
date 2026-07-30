#' Add experimental condition labels
#'
#' Adds baseline and cue conditions.
#'
#' @param data Simulated dataset.
#'
#' @return Updated dataset.
#'
#' @export

add_condition <- function(data){
  
  data$condition <- ifelse(
    data$time >= 40 &
      data$time <= 80,
    1,
    0
  )
  
  return(data)
  
}