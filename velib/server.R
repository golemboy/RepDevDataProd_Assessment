library(shiny)
library(dplyr)
source(paste0(getwd(),"/datasource.R"))
shinyServer(
  function(input, output) {
    
    itop <- renderPrint({input$top})
    ibike_stand <- renderPrint({input$bike_stand})
    
    
    num_row <- "1000" #"1230"
    contract_name<-"Paris" 
    velib_json <-"http://opendata.paris.fr/api/records/1.0/search?dataset=stations-velib-disponibilites-en-temps-reel&rows=%s&facet=banking&facet=bonus&facet=status&facet=bike_stands&facet=available_bike_stands&facet=available_bikes&facet=last_update&facet=name&refine.contract_name=%s"  
    
    dt <- get_data(velib_json)
    #selectedData <- reactive(get_top_bikes(dt, input$top, input$bike_stand))
    
    
    output$mytable = renderDataTable({
      #selectedData
      get_top_bikes(dt, input$top, input$bike_stand,input$borough)
    })
    
    
    
    output$otop <- itop
    output$obike_stand <- ibike_stand
    
#     output$oid1 <- renderPrint({input$top})
#     output$oid2 <- renderPrint({input$id2})
#     output$odate <- renderPrint({input$date})
#     output$obins <- renderPrint({input$bins})
  }
)