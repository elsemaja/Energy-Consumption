###############################################################################
#                                                                             #
#   DESCRIPTION: IoT, Smart Homes and Sub-meters                              #
#   SCRIPT FUNCITON: Forecasting with prophet and daily averages of power     #
#   consumption to predict energy use for next 365 days                       #
#   Version: 1                                                                #
#   NAME: Else                                                                #
#                                                                             #
###############################################################################

# run previous scripts
source('2. Pre-processsing - engineering and subsetting - final.R')

# Decide what your dependent variable will be,  
# NECESSARY: rename column Date in 'ds' & change dependent variable in 'y'
# it is possible to forecast other variables, this analysis is done on GAP
# it is also possible to work with the gather function
GAPdaily <- rename(DailyMean, ds = Date,y = mean_gap)

# Select 'ds' and 'y' for dataframe
GAPdaily <- select(GAPdaily, ds, y)

# Create prophet model
ModelGAP <- prophet(GAPdaily, daily.seasonality = TRUE)

# Make future dataframe for 365 days
futureGAP <- make_future_dataframe(ModelGAP, periods = 365, include_history = TRUE)

# Make forecast of future 365 days
forecastGAP <- predict(ModelGAP, futureGAP)
