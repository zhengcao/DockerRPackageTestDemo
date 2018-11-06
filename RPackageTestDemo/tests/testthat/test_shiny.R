library(testthat)
library(shinytest)

context("shiny")

app <- ShinyDriver$new("C:/RProjects/RPackageTestDemo/R/")

test_that("output is correct", {
  app$setInputs(num_input = 30)
  output <- app$getValue(name = "text_out")
  expect_equal(output, "The square of the number n is: n2 = 900")
})

app$stop()
