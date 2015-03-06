library(shiny)
library(dplyr)
source(paste0(getwd(),"/datasource.R"))
shinyServer(
  function(input, output) {
    
    itop <- renderPrint({input$top})
    
    
    num_row <- "100" #"1230"
    contract_name<-"Paris" 
    velib_json <-"http://opendata.paris.fr/api/records/1.0/search?dataset=stations-velib-disponibilites-en-temps-reel&rows=%s&facet=banking&facet=bonus&facet=status&facet=bike_stands&facet=available_bike_stands&facet=available_bikes&facet=last_update&facet=name&refine.contract_name=%s"  
    
    # got a dataframe of list
    dtl <- get_data(velib_json)
    
    # separate into 2 dataframe, 1 frame with geo coordinate and recordid
    geo_data <- select(dtl, c(2,14:16))
    
    #one dataframe with other information (all column are unlisted)
    velib_data <- as.data.frame(lapply(select(dtl, -c(14:16)), unlist),stringsAsFactors=FALSE)
    
    #
    dts <- velib_data %>% 
      arrange(desc(fields.last_update), desc(fields.available_bikes), desc(fields.available_bike_stands)) %>%
      filter(fields.status == "OPEN") %>%
      mutate(fields.zipcode = get_zipcode(fields.address)) %>%
      select(recordid, fields.name, fields.zipcode, fields.available_bikes, fields.available_bike_stands, fields.bonus, fields.last_update)
    
    dts$fields.zipcode
    
    selectedData <- reactive(top_available_bikes <- get_top_available_bikes(dts,input$top))
    
    #top_available_bike_stands <- get_top_available_bike_stands(dts,itop)
    
    output$otop <- itop
    
#     output$oid1 <- renderPrint({input$top})
#     output$oid2 <- renderPrint({input$id2})
#     output$odate <- renderPrint({input$date})
#     output$obins <- renderPrint({input$bins})
  }
)