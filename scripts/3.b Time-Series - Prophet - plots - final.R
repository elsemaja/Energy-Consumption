###############################################################################
#                                                                             #
#   DESCRIPTION: IoT, Smart Homes and Sub-meters                              #
#   SCRIPT FUNCITON: Plotting with prophet to see forecasted daily averages   #
#   of power consumption for next 365 days                                    #
#   Version: 1                                                                #
#   NAME: Else                                                                #
#                                                                             #
###############################################################################

# run previous scripts
source('3.b Time-Series - Prophet - analysis - final.R')

# Make plots of forecasts ----
# simpel plot
plot(ModelGAP, forecastGAP)

# Check for trend, weekly and yearly patterns in components plot
prophet_plot_components(ModelGAP, forecastGAP, weekly_start = 1)

# use the interactive dyplot to investigate and zoom in
dyplot.prophet(ModelGAP, forecastGAP)

