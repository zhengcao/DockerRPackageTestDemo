#' the RPackageTestDemo app
#'
#' @export app
#'
#' @return shiny application object
#'
#' @import shiny

app <- function() {

  ui <- fluidRow(title = 'Minimal app',
                 numericInput("num_input", "Please insert a number n:", 0),
                 textOutput('text_out')
  )

  server <- function(input, output, session) {
    # Namespace RPackageTestDemo is used to solve shinytest issue
    result <- reactive(RPackageTestDemo::square(input$num_input))
    output$text_out <- renderText(
      paste("The square of the number n is: n2 =", result())
    )
  }

  shinyApp(ui, server)
}

# Not sure why this is required, but shinytest won't work without this line...
app()

