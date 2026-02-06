#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(
    
    # Application title
    titlePanel("CA National Park Visitor Data"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("myPark", "What's your favourite park in CA?",
                        choices = unique(ca_np_decade_avg$Park),
                        selected = "Channel Islands",
                        multiple = FALSE
            ),
            
            radioButtons("myTime", "Choose the number of years of aggregation:",
                         choices = list(5,10, 20),
                         selected = "10",
                         multiple = FALSE
            )
        )
        ,
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs",
                        
                        # Tab 1
                        tabPanel("ggplot Tab", 
                                 br(),
                                 plotOutput("parkPlot")
                        ),
                        
                        # Tab 2
                        tabPanel("Plotly Tab", 
                                 br(),
                                 # plotlyOutput("plotly")
                                 plotOutput("parkPlot")
                        )
                        
            )    # closes tabset
        )        # closes main panel
    )            # closes sidebar layout
)

