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
 
    # # Server Side: Use renderDT
    # output$my_table <- renderDT({
    #     
    #     # You can pass standard data frames or matrices here
    #     datatable(ca_np_long, 
    #               options = list(pageLength = 5), # Show only 5 rows by default
    #               rownames = FALSE)              # Hide row names
    # })

    output$parkPlot <- renderPlot({
        # Compute the decade of each year
        ca_np_decade <- ca_np_long %>%
            mutate(Decade = Year - (Year %% as.integer(input$myTime)),
                   Month = factor(Month, levels = month.abb, labels = month.abb)
            ) %>%
            relocate(Decade, .after = Park)

        # Compute the decadal average for each month per park
        ca_np_decade_avg <- ca_np_decade %>%
            group_by(Park, Decade, Month) %>%
            summarise(Decadal_avg = as.integer(mean(NoVisitors, na.rm=TRUE))) %>%
            ungroup()

        # filter park based on selection
        park_data <- ca_np_decade_avg %>%
            filter(Park == input$myPark)

        # generate the plot
        ggplot(data = park_data, mapping = aes(x = Month, y = Decadal_avg, group = Decade, color = as.character(Decade))) +
            geom_line() +
            labs(color = "Decade") +
            # scale_color_viridis() +
            scale_y_continuous(labels = comma) +
            ggtitle("NPS Channel Island - Decadal Average of monthly visitors") +
            theme_bw() +
            theme(axis.title.x = element_blank(), axis.title.y = element_blank())

    }) # closes ggplot
    
    

    # Do the same for plotly (there must be a more efficient way)
    output$plotly <- renderPlotly({
        # Compute the decade of each year
        ca_np_decade <- ca_np_long %>%
            filter(Year > 1979) %>%                # We only have 1979 in the 70s
            mutate(Decade = Year - (Year %% as.integer(input$myTime)),
                   Month = factor(Month, levels = month.abb, labels = month.abb)
            ) %>%
            relocate(Decade, .after = Park)


        # Compute the decadal average for each month per park
        ca_np_decade_avg <- ca_np_decade %>%
            group_by(Park, Decade, Month) %>%
            summarise(Decadal_avg = as.integer(mean(NoVisitors, na.rm=TRUE))) %>%
            ungroup()

        # filter park based on selection
        park_data <- ca_np_decade_avg %>%
            filter(Park == input$myPark)

        # generate the plot
        park_p <- ggplot(data = park_data, mapping = aes(x = Month, y = Decadal_avg, group = Decade, color = as.character(Decade))) +
            geom_line() +
            labs(color = "Decade") +
            # scale_color_viridis() +
            scale_y_continuous(labels = comma) +
            ggtitle("NPS Channel Island - Decadal Average of monthly visitors") +
            theme_bw() +
            theme(axis.title.x = element_blank(), axis.title.y = element_blank())
        ggplotly(park_p, tooltip = c("Decade", "x", "y"))
    }) # closes plotly
    
}
