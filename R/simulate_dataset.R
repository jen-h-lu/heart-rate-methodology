#' Simulate a physiological dataset
#'
#' Generates repeated physiological trajectories for multiple participants.
#'
#' @param n_subjects Number of participants.
#' @param response Response profile.
#' @param amplitude Effect size.
#' @param seed Random seed.
#'
#' @return A simulated dataset.
#'
#' @export


simulate_dataset <- function(
    n_subjects,
    response = "null",
    amplitude = 3,
    rho = 0,
    seed = NULL
){
  
  if (!is.null(seed)) {
    set.seed(seed)
  }
  
  
  # Define measurement timeline
  time <- seq(
    0,
    120,
    by = 10
  )
  
  
  # Generate participant characteristics
  subjects <- generate_subjects(
    n = n_subjects
  )
  
  
  # Generate physiological response trajectory
  response_curve <- generate_response_curve(
    time = time,
    response = response,
    amplitude = amplitude
  )
  
  
  # Generate repeated observations
  simulated_data <- purrr::map_dfr(
    
    seq_len(nrow(subjects)),
    
    function(i) {
      
      
      baseline <- subjects$baseline_hr[i]
      
      random_effect <- subjects$random_effect[i]
      
      
      tibble::tibble(
        
        subject = subjects$subject[i],
        
        time = time,
        
        baseline_hr = baseline,
        
        random_effect = random_effect,
        
        response = response_curve,
        
        
        observed_hr = baseline_hr +
          random_effect +
          response_curve +
          generate_ar_noise(
            length(time),
            rho=rho,
            sigma=4
          )
        
      )
      
    }
    
  )
  
  
  simulated_data
  
}