library(shiny)
shinyServer(
  function(input, output) {
      output$foo <- "a"
#     output$oid1 <- renderPrint({input$id1})
#     output$oid2 <- renderPrint({input$id2})
#     output$odate <- renderPrint({input$date})
#     output$obins <- renderPrint({input$bins})
  }
)