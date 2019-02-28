###############################################################################
#                                                                             #
#   DESCRIPTION: IoT, Smart Homes and Sub-meters                              #
#   SCRIPT FUNCITON:                                                          #
#   Create plots of linear regression and Holt Winters forecast for average   #
#   power consumption of the Global Active Power for next 365 days            #
#   Version: 2                                                                #
#   NAME: Else                                                                #
#                                                                             #
###############################################################################

# run previous scripts
source('3.a Time-Series - Linear Regression and Holt Winters - analysis - final.R')

# plot the Time Series (TS) data ----
plot.ts(tsGAP_DailyMean, xlab = "Time", ylab = "Watt Hours", 
        main = "Average Power Consumption per Day")

# plot the decomposed graphs of the TS
plot(DecomTsGAP_DailyMean)

# plot the forecast of the linear regression model
plot(forecastfitGAP,     
          main = "Forecast: average energy consumption",
          ylim = c(0, 45),
          xlab = "Time",
          ylab = "Power (watt-hour)",
          col = "purple")

# plot the forecasts of the linear regression model with confidence 80/90 ----
plot(forecastfitGAPc,     
     main = "Forecast: average energy consumption",
     ylim = c(0, 45),
     xlab = "Time",
     ylab = "Power (watt-hour)",
     col = "purple")


# Holt Winters Forecasting plots ----
# check seasonal adjustment by plotting after decompose
plot(decompose(tsGAP_Adjusted))

# check Holt Winters plots after exponential smoothing
plot(tsGAP_HW, ylim = c(0, 45))

# plot Holt winters forecasting plot
plot(tsGAP_HW_FC, 
     main = "Holt Winters Forecast total",
     ylim = c(0, 45), 
     ylab= "Watt-Hours", 
     xlab= "Time")

# forecast Holt Winters with diminished confidence levels and plot only the forecasted area ----
plot(tsGAP_HW_FC_C, 
     main = "Holt Winters Forecast average GAP",
     ylim = c(9, 20), 
     ylab= "Watt-Hours", 
     xlab="Time", 
     start(2010))
