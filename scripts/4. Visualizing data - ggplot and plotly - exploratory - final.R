###############################################################################
#                                                                             #
#   DESCRIPTION: IoT, Smart Homes and Sub-meters                              #
#   SCRIPT FUNCITON: Create plots for hourly, daily, weekly, montly, yearly   #
#   averages.                                                                 #
#   Version: 1                                                                #
#   NAME: Else                                                                #
#                                                                             #
###############################################################################


# run previous scripts
source('2. Pre-processsing - engineering and subsetting - final.R')

# plot the monthly means of GAP to compare yearly trends
ggplot(MonthlyMean, aes(x=Month, y=mean_gap, group=Year)) +
  geom_line(aes(color=Year)) +
  theme_classic()+
  theme(legend.position="right")+
  labs(y = "Power (watt hour)",
       title = "Power Consumption between 2007 and 2010")

# plot trend over the years of GAP, you can plot other sub meters to investigate, 
# or change the data frame to look at months, days or hours.
ggplot(YearlyMean, aes(x = Year, y = mean_gap, group = 1)) +
  geom_line()+
  theme_classic()+
  theme(legend.position="right")+
  labs(y = "Power (watt hour)",
       title = "Power Consumption between 2007 and 2010")

# combine all submeters and include titel, labs, color
plotMean <- ggplot(YearlyMean, aes(x = Year, y=mean_gap))
plotMean + geom_line(aes(x=Year, y= mean_sub1, group =1), colour="#3385D7") +
  geom_line(aes(x=Year, y= mean_sub2, group =1), colour="#F7D749") +
  geom_line(aes(x=Year, y= mean_sub3, group =1), colour="#5DD733") +
  geom_line(aes(x=Year, y= mean_sub4, group =1), colour="#CD241C") + 
  theme_classic()+
  labs(y = "Power (watt hour)",
       title = "Power Consumption between 2007 and 2010",
       subtitle = "divided by sub meters")


# use facet wrap to split the graph by year, month or weekday 
# and split graphs according to season
ggplot(data=MonthlyMean, aes(x=Month, y=mean_gap, group=Year)) +
  geom_line(aes(color=Year)) +
  theme_bw()+
  facet_wrap(~Quarter)+
  theme(legend.position="right")+
  labs(y = "Power (watt hour)",
       title = "Power Consumption between 2007 and 2010")

# plot the daily averages in one graph with a gathered dataset
ggplot(DailyMeanGathered, aes(x=ds)) +
  geom_line(aes(x=ds, y=y, col = sub)) +
  theme_classic()+
  theme(legend.position="right")+
  labs(y = "Power (watt hour)",
       title = "Power Consumption between 2007 and 2010")

# use Plotly for interactive graphs ----
# subset and filter the data according to your wishes to start exploration
# for example a single day with a 10 Minute frequency

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


# try scatterplot
plot_ly(DailyMean) %>%
  add_trace(DailyMean,
            x= ~DailyMean$Date, 
            y =~DailyMean$mean_sub1, 
            type = "scatter", 
            color = "blue",
            opacity = 0.8,
            mode = "markers",
            name = "Kitchen (Sub meter 1)") %>%
  add_trace(DailyMean,
            x= DailyMean$Date, 
            y = DailyMean$mean_sub2, 
            opacity = .1,
            type = "scatter", 
            color = "purple",
            mode = "markers",
            name = "Laundry Room (Sub meter 2)") %>%
  add_trace(DailyMean,
            x= DailyMean$Date, 
            y = DailyMean$mean_sub3, 
            opacity = .5,
            type = "scatter", 
            color = "black",
            mode = "markers",
            name = "Water Heater and AC (Submeter 3)") %>%
  add_trace(DailyMean,
            x= DailyMean$Date, 
            y = DailyMean$mean_sub4, 
            type = "scatter", 
            color = "grey",
            mode = "markers",
            name = "Unknown (No Sub meter)") %>%
  layout(title = "Power Consumption",
         xaxis = list(title = "Time"),
         yaxis = list (title = "Power (watt-hours)"))

# Create a basic pie ----
# chart for the energy consumption during a whole month in summer
JUL08 <- yrs_2007tm2010 %>%
  filter(Year == 2008,
         Month == 7) %>%
  group_by(Month) %>%
  summarise(SM1 = mean(Sub_metering_1),
            SM2 = mean(Sub_metering_2),
            SM3 = mean(Sub_metering_3),
            SM4 = mean(Sub_metering_4),
            TOT = mean(GAP))

JUL08

# Simple Pie Chart
slices <- c(1.06,
            0.976, 
            5.09, 
            6.04)
lbls <- c("Kitchen",
          "Laundry Room",
          "Water Heater & AC",
          "Unknown")
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, pct) # add percents to labels 
lbls <- paste(lbls,"%",sep="") # ad % to labels 
pie(slices,labels = lbls,
    main="Average distribution of Energy Consumption (July, 2008)")




