# Generate autoregressive AR(1) noise
#
# epsilon_t = rho * epsilon_(t-1) + eta_t


generate_ar_noise <- function(
    n,
    rho = 0,
    sigma = 4
){
  
  noise <- numeric(n)
  
  
  # First observation
  
  noise[1] <- rnorm(
    1,
    mean = 0,
    sd = sigma
  )
  
  
  # AR(1) process
  
  for(i in 2:n){
    
    noise[i] <-
      rho * noise[i-1] +
      rnorm(
        1,
        mean = 0,
        sd = sigma
      )
    
  }
  
  
  noise
  
}