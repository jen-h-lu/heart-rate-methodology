#' Add missing observations
#'
#' Simulates missing physiological measurements.
#'
#' @param data Dataset.
#' @param proportion Missing proportion.
#'
#' @return Dataset with missing values.
#'
#' @export

add_missingness <- function(
    data,
    missing_rate = 0
){
  
  if(missing_rate == 0){
    return(data)
  }
  
  
  data %>%
    mutate(
      observed_hr =
        ifelse(
          runif(n()) < missing_rate,
          NA,
          observed_hr
        )
    )
  
}