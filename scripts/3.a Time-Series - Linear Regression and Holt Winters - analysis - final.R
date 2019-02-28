###############################################################################
#                                                                             #
#   DESCRIPTION: IoT, Smart Homes and Sub-meters                              #
#   SCRIPT FUNCITON:                                                          #
#   Create forecasts with linear regression and Holt Winters for average power#
#   consumption of the Global Active Power for next 365 days                  #
#   Version: 2                                                                #
#   NAME: Else                                                                #
#                                                                             #
###############################################################################

# run previous scripts
source('2. Pre-processsing - engineering and subsetting - final.R')

# Here I used the subset "DailyMean" from 2007, 2008, 2009 and 2010 ----
# it is possible to use other subsets or forecast other attributes.
# in this script average global active power is predicted

# Create TS object of average energy consumption for all meters and total.
tsGAP_DailyMean <- ts(DailyMean$mean_gap, frequency = 365, start = c(2007, 1))

# Decompose into trend, seasonal and remainder ----
DecomTsGAP_DailyMean <- decompose(tsGAP_DailyMean)

# Linear Regression Forecasting ----
# apply time series linear regression to the GAP 
fitGAP <- tslm(tsGAP_DailyMean ~ trend + season) 

# create the forecasts and choose the amount of time periods to predict
forecastfitGAP <- forecast(fitGAP, h=365)

# Create forecasts with confidence levels 80 and 90 ----
forecastfitGAPc <- forecast(fitGAP, 
                            h=365, 
                            level=c(80,90))

# Holt Winters Forecasting ----
# Seasonal adjusting by subtracting the seasonal component & plot
tsGAP_Adjusted <- tsGAP_DailyMean - DecomTsGAP_DailyMean$seasonal

# Holt Winters Exponential Smoothing & Plot ----
tsGAP_HW <- HoltWinters(tsGAP_Adjusted, beta=FALSE, gamma=FALSE)

# HoltWinters forecast ----
tsGAP_HW_FC <- forecast(tsGAP_HW, h=365)

# Forecast HoltWinters with diminished confidence levels ----
tsGAP_HW_FC_C <- forecast(tsGAP_HW, h=365, level=c(10,25))

