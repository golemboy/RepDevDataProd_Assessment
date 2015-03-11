library(shiny)
# shinyUI(pageWithSidebar(
#     headerPanel("Data science FTW!"),
#     sidebarPanel(      
#       radioButtons("bonus", "Station with bonus", c(TRUE, FALSE), selected = FALSE, inline = FALSE)
#     ),
#     mainPanel(
#       h3('Results of prediction')
#     )
# ))

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel("Telephones by region"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        selectInput("top", "Top", choices=c(10,15,20)),
        selectInput("borough", "Borough", choices=1:20),
        
        #radioButtons("bonus", "Station with bonus", c(TRUE, FALSE, NA), selected = NA, inline = FALSE),
        radioButtons("bike_stand","Top available", c("bike stand"=TRUE,"bike"=FALSE), selected = FALSE, inline = FALSE),
        hr(),
        helpText("Data from AT&T (1961) The World's Telephones.")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        
        #plotOutput("phonePlot")  
        h1('Results of prediction'),
        h4("Summary"),
        tabsetPanel(
          tabPanel('diamonds',
                   h4("Observations"),
                   dataTableOutput("mytable"),
                  verbatimTextOutput("obike_stand")),
          tabPanel('mtcars',
                   h4("Observations"),
                   #dataTableOutput("mytable"),
                   verbatimTextOutput("otop"))          
        )              
      )
    )
  )
)