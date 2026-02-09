#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

## Read the data ----


# Path
data_path <- file.path("data_processed", "nps_ca-np-rec-visit_long.csv")

# Read data in
ca_np_long <-  data_path %>%
    read_csv() %>%
    filter(Year > 1979 & Year < 2026)       # We only have 1979 in the 70s and partial 26

# Define server logic required to plot
function(input, output, session) {
 
    # Create a reactive expression
    park_data_reactive <- reactive({
      
      ca_np_long %>%
        # filter park based on selection
        filter(Park == input$myPark) %>%
        # add the time window based on selection
        mutate(Decade = Year - (Year %% as.integer(input$myTime)),
               Window = paste0(Decade, "-", Decade + as.integer(input$myTime) - 1),
               Month = factor(Month, levels = month.abb, labels = month.abb)) %>%
        relocate(Window, .after = Park) %>%
        # compute monthly average of timewindow
        group_by(Park, Window, Month) %>%
        summarise(MonthlyAve = as.integer(mean(NoVisitors, na.rm=TRUE))) %>%
        ungroup()
        
    }) # close reactive
    
    
    # Server side: Use renderPlot for ggplot tab
    output$parkPlot <- renderPlot({
      
      ggplot(data = park_data_reactive(), 
             mapping = aes(x = Month, y = MonthlyAve, group = Window, color = Window)) +
        geom_line() +
        labs(color = "Time Window") +
        scale_color_viridis_d() +
        scale_y_continuous(labels = comma) +
        ggtitle("Monthly Visitors to Channel Islands") +
        theme_bw() +
        theme(axis.title.x = element_blank(), axis.title.y = element_blank())
      
    }) # closes ggplot
    
    
    
    # Server side: Use renderPlotly for plotly tab
    output$plotly <- renderPlotly({
      
      # generate the plot
      park_p <- ggplot(data = park_data_reactive(), 
                       mapping = aes(x = Month, y = MonthlyAve, group = Window, color = Window)) +
        geom_line() +
        labs(color = "Time Window") +
        scale_color_viridis_d() +
        scale_y_continuous(labels = comma) +
        ggtitle("Monthly Visitors to Channel Islands") +
        theme_bw() +
        theme(axis.title.x = element_blank(), axis.title.y = element_blank())
      
      # pass through ggplotly
      ggplotly(park_p, tooltip = c("x", "y", "Window"))
      
    }) # closes plotly
    
  
    
    # Server Side: Use renderDT for interactive table tab
    output$my_table <- renderDT({
        
      park_data_reactive() %>%
        pivot_wider(id_cols = c("Park", "Window"), names_from = "Month", values_from = MonthlyAve) %>%
        datatable(options = list(pageLength = 10),    # Show only 5 rows by default
                  rownames = FALSE) %>%
        formatRound(
          columns = 3:14,  # columns with numeric values 
          digits = 0,      # no decimals
          mark = ","       # thousand separator
        )
        
    })
    
}
