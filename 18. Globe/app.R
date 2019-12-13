#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(
    fluidPage(
        fluidRow(
            column(12, plotlyOutput("plot", height = "800px"))
        )
    )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$plot <- renderPlotly({
        
        df2 <- read.csv("total-alcohol-consumption-per-capita-litres-of-pure-alcohol.csv") %>% 
            janitor::clean_names() %>% 
            as_tibble()
        
        names(df2)[c(1,2,4)] <- c("COUNTRY", "CODE", "alc_cons")
        
        df <- df2
        
        
        #Set country boundaries as light grey
        l <- list(color = toRGB("#d1d1d1"), width = 0.5)
        #Specify map projection and options
        g <- list(
            showframe = FALSE,
            showcoastlines = FALSE,
            projection = list(type = 'orthographic'),
            resolution = '100',
            showcountries = TRUE,
            countrycolor = '#d1d1d1',
            showocean = TRUE,
            oceancolor = '#c9d2e0',
            showlakes = TRUE,
            lakecolor = '#99c0db',
            showrivers = F,
            rivercolor = '#99c0db')
        
        p <- plot_geo(df) %>%
            add_trace(z = ~alc_cons, color = ~alc_cons, colors = 'BuPu',
                      text = ~COUNTRY, locations = ~CODE, marker = list(line = l)) %>%
            colorbar(title = 'Litros de Alcohol <br>Consumido por persona <br>mayor de 15 años <br><b>Fuente: </b> Our World In Data / Consumo de Alcohol') %>%
            layout(title = '', geo = g)
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
