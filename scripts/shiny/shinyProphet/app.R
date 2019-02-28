# library ----
library("shiny")
library("shinydashboard")
library("dygraphs")
library("Cairo")

# import data ----
DailyMean <- readRDS(file = "dataShiny.rds")
sub_choices <- c("mean_sub1", "mean_sub2", "mean_sub3", "mean_sub4", "mean_gap")

library(shiny)

ui <- dashboardPage(
  
  dashboardHeader(title = "Show me the data"),
  
  dashboardSidebar(
    selectInput(
      inputId = 'submeterSelection',
      label = 'Select you sub meter: ',
      choices = sub_choices,
      selected = "mean_gap")
  ),
 
  dashboardBody(
    fluidRow(
      box(
        width = 14,
        plotlyOutput("DayPlotly")
      )
    ),
    fluidRow(
      box(
        width = 14,
        dygraphOutput(outputId = "plotProphetForecast")
        )
      ),
    fluidRow(
      splitLayout(cellWidths = c("50%", "50%"), plotOutput(outputId = "prophetComp"), plotOutput("MeanGapPlot"))
      )
    )
  )

    
server <- function(input, output, session) {
  
  output$plotProphetForecast <- renderDygraph({
    
    GAPdaily <- DailyMean %>% 
      gather(key = 'sub', value = 'value', 
             mean_sub1, mean_sub2, mean_sub3, mean_sub4, mean_gap) %>% 
      rename(ds = Date,
             y = value)
    
    # Select 'ds' and 'y' for dataframe
    GAPdaily <- filter(GAPdaily, sub == input$submeterSelection) 
    
    # Create prophet model
    ModelGAP <- prophet(GAPdaily, daily.seasonality = TRUE)
    
    # Make future dataframe for 365 days
    futureGAP <- make_future_dataframe(ModelGAP, periods = 365, include_history = TRUE)
    
    # Make forecast of future 365 days
    forecastGAP <- predict(ModelGAP, futureGAP)
    
    # Plot the forecast and its components ----
    plot(ModelGAP, forecastGAP)
    
    # interactive graph with prophet
    dyplot.prophet(ModelGAP, forecastGAP)
  })
  
  output$DayPlotly <- renderPlotly({
  
    SELECTION <- yrs_2007tm2010 %>%
      filter(Year == 2007,
             Month == 2 &
               Day == 16 &
               (Minute == 0 | 
                  Minute == 10 | 
                  Minute == 20 | 
                  Minute == 30 | 
                  Minute == 40 | 
                  Minute == 50))
    
    
    # Plot all meters with legend and labels 
    plot_ly(SELECTION, 
            x = ~SELECTION$DateTime,
            y = ~SELECTION$Sub_metering_1, 
            name = 'Kitchen',
            type = 'scatter', 
            mode = 'lines') %>%
      add_trace(y = ~SELECTION$Sub_metering_2, 
                name = 'Laundry Room', 
                mode = 'lines') %>%
      add_trace(y = ~SELECTION$Sub_metering_3, 
                name = 'Water Heater & AC', 
                mode = 'lines') %>%
      add_trace(y = ~SELECTION$Sub_metering_4, 
                name = 'Unknown', 
                mode = 'lines') %>%
      layout(title = "Power Consumption",
             xaxis = list(title = "Time"),
             yaxis = list (title = "Power (watt-hours)"))
  })
  
  
  output$MeanGapPlot <- renderPlot({
    
    ggplot(YearlyMean, aes(x = Year, y=mean_gap, group = 1)) +
      geom_line() +
      theme_classic()+
      theme(legend.position="right")+
      labs(y = "Power (watt hour)",
           title = "Power Consumption between 2007 and 2010")
  })
    
  output$prophetComp <- renderPlot({
    
    GAPdaily <- DailyMean %>% 
      gather(key = 'sub', value = 'value', 
             mean_sub1, mean_sub2, mean_sub3, mean_sub4, mean_gap) %>% 
      rename(ds = Date,
             y = value)
    
    # Select 'ds' and 'y' for dataframe
    GAPdaily <- filter(GAPdaily, sub == input$submeterSelection) 
    
    # Create prophet model
    ModelGAP <- prophet(GAPdaily, daily.seasonality = TRUE)
    
    # Make future dataframe for 365 days
    futureGAP <- make_future_dataframe(ModelGAP, periods = 365, include_history = TRUE)
    
    # Make forecast of future 365 days
    forecastGAP <- predict(ModelGAP, futureGAP)
    
    # Plot the forecast and its components ----
    plot(ModelGAP, forecastGAP)
    
    prophet_plot_components(ModelGAP, forecastGAP, weekly_start = 1)
    
  })
    
}

shinyApp(ui, server)
