add_condition <- function(data){
  
  data$condition <- ifelse(
    data$time >= 40 &
      data$time <= 80,
    1,
    0
  )
  
  return(data)
  
}