# Randomly remove physiological observations

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