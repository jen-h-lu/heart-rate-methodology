library(testthat)
library(physioSim)

test_that("response curve has correct length", {
  
  x <- generate_response_curve(
    time = seq(0, 60, 1),
    response = "immediate"
  )
  
  expect_equal(length(x), 61)
  
})

test_that("null response is all zeros", {
  
  x <- generate_response_curve(
    time = seq(0, 60, 1),
    response = "null"
  )
  
  expect_true(all(x == 0))
  
})

test_that("immediate response is numeric", {
  
  x <- generate_response_curve(
    time = seq(0, 60, 1),
    response = "immediate"
  )
  
  expect_true(is.numeric(x))
  
})

test_that("delayed response is numeric", {
  
  x <- generate_response_curve(
    time = seq(0, 60, 1),
    response = "delayed"
  )
  
  expect_true(is.numeric(x))
  
})

test_that("habituation response is numeric", {
  
  x <- generate_response_curve(
    time = seq(0, 60, 1),
    response = "habituation"
  )
  
  expect_true(is.numeric(x))
  
})

test_that("sustained response is numeric", {
  
  x <- generate_response_curve(
    time = seq(0, 60, 1),
    response = "sustained"
  )
  
  expect_true(is.numeric(x))
  
})

test_that("invalid response throws an error", {
  
  expect_error(
    
    generate_response_curve(
      time = seq(0, 60, 1),
      response = "banana"
    )
    
  )
  
})