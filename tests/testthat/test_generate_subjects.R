library(testthat)
library(physioSim)

test_that("generate_subjects returns correct number of rows", {
  
  subjects <- generate_subjects(
    n = 25
  )
  
  expect_equal(
    nrow(subjects),
    25
  )
  
})

test_that("subject IDs are unique", {
  
  subjects <- generate_subjects(
    n = 100
  )
  
  expect_equal(
    
    length(unique(subjects$subject)),
    
    100
    
  )
  
})

test_that("baseline heart rates are numeric", {
  
  subjects <- generate_subjects(
    n = 50
  )
  
  expect_true(
    
    is.numeric(
      subjects$baseline_hr
    )
    
  )
  
})

test_that("random effects are numeric", {
  
  subjects <- generate_subjects(
    n = 50
  )
  
  expect_true(
    
    is.numeric(
      subjects$random_effect
    )
    
  )
  
})