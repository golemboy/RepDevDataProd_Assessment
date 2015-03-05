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
        selectInput("top", "Top", choices=c(5,10,15,20)),
        selectInput(
          "breaks", "Breaks",
          c("Sturges",
            "Scott",
            "Freedman-Diaconis",
            "[Custom]" = "custom")),
        radioButtons("bonus", "Station with bonus", c(TRUE, FALSE), selected = FALSE, inline = FALSE),
        hr(),
        helpText("Data from AT&T (1961) The World's Telephones.")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        #plotOutput("phonePlot")  
        h1('Results of prediction'),
        h4("Summary"),
        conditionalPanel(
            condition = "input.breaks == 'custom'",
           sliderInput("breakCount", "Break Count", min=1, max=1000, value=10)
        ),
                
        h4("Observations"),
        tableOutput("view")
      )
      
    ),
    sidebarLayout(sidebarPanel, mainPanel, position = c("left", "right"), fluid = TRUE)
  )
)