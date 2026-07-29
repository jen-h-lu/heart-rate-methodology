# Default simulation parameters for physioSim

default_parameters <- list(
  
  # Population
  baseline_mean = 72,
  baseline_sd = 6,
  subject_sd = 3,
  
  # Time
  start_time = 0,
  end_time = 300,
  time_step = 5,
  
  # Response
  amplitude = 12,
  peak_time = 60,
  
  # Noise
  noise_sd = 2,
  
  # Autocorrelation
  phi = 0.6,
  
  # Missingness
  missing_rate = 0
)