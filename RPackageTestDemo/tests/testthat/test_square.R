library(testthat)

context("square")

test_that("output is correct", {
  expect_equal(square(4), 16)
})
