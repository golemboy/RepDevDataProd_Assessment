library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Illustrating inputs"),
  sidebarPanel(
    numericInput('id1', 'un label pour le Numeric input', 6, min = 0, max = 10, step = 1),
    checkboxGroupInput("id2", "Label pour la Checkbox",
                       c("Value 1" = "1",
                         "Value 2" = "2",
                         "Value 3" = "3"),
                       selected = c("Value 1",
                                    "Value 2")),
    
    dateInput("date", "Date:"),
    sliderInput("bins",
                "Number of bins:",
                min = 1,
                max = 50,
                value = 30) 
    
  ),
  mainPanel(
    h3('Illustrating outputs'),
    h4('Numeric input'),
    verbatimTextOutput("oid1"),
    h4('CheckboxGroup'),
    verbatimTextOutput("oid2"),
    h4('Date input'),
    verbatimTextOutput("odate"),
    h4('Slider input'),
    verbatimTextOutput("obins")
    
  )
))

