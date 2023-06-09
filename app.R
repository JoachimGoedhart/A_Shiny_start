#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Iris data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          h2("Plot Controls"), hr(),
          sliderInput("bins",
                      "Number of bins:",
                      min = 1,
                      max = 50,
                      value = 30),
          numericInput("transparency", "Transparency:", value = 0.7, min = 0, max = 1, step = 0.1),
          textInput("title", "Title:", value = "Plot title"),
          selectInput(inputId = "var", label = "Variable", choices = c("Sepal.Length", "Sepal.Width")),
          checkboxInput("ungroup", "Per species?", value = FALSE),
          conditionalPanel(condition = "input.ungroup==true", "The plot shows the data per species")
          ),
        
        # Show a plot and table
        mainPanel(
           plotOutput("distPlot"),tableOutput("someTable")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(session, input, output) {

    output$distPlot <- renderPlot({
      p <- ggplot(data = iris, aes(x=.data[[input$var]])) + geom_histogram(bins = input$bins, alpha=input$transparency)
      if (input$ungroup == TRUE) p <- p + facet_wrap(~Species)
      p <- p + labs(title = input$title)
      p <- p + theme_bw(base_size = 16)
      return(p)
    })
    
    output$someTable <- renderTable({
      iris %>% group_by(Species) %>% summarise(n=n(), mean = mean(.data[[input$var]]))
    })
    
    observe({
      df_num <- iris %>% select(where(is.numeric))
      colNames <- colnames(df_num)
      updateSelectInput(session, inputId = "var", choices = colNames)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
