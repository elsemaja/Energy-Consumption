###############################################################################
#                                                                             #
#   DESCRIPTION: IoT, Smart Homes and Sub-meters                              #
#   SCRIPT FUNCITON:                                                          #
#   Create subsets                                                            #
#   Version: 2                                                                #
#   NAME: Else                                                                #
#                                                                             #
###############################################################################

# get the data ----
yrs_2007tm2010 <- readRDS(file = 'data/totalData.rds')

# subset averages per hour, day, week, month, year for exploration ---- 
# hourly
HourlyMean <- yrs_2007tm2010 %>%
  group_by(Year,Weekday, Day,Date, Hour) %>%
  summarise(mean_sub1 = mean(Sub_metering_1), 
            mean_sub2 = mean(Sub_metering_2),
            mean_sub3 = mean(Sub_metering_3),
            mean_sub4 = mean(Sub_metering_4),
            mean_gap = mean(GAP))

# daily
DailyMean <- yrs_2007tm2010 %>%
  group_by(Date) %>%
  summarise(mean_sub1 = mean(Sub_metering_1), 
            mean_sub2 = mean(Sub_metering_2),
            mean_sub3 = mean(Sub_metering_3),
            mean_sub4 = mean(Sub_metering_4),
            mean_gap = mean(GAP))

# gather all the values of the submeters in one column and turn columns of submeters
# into values. Later this dataframe is used for the shiny app, to filter the 
# values of the corresponding submeters.
DailyMeanGathered <- DailyMean %>% 
  gather(key = 'sub', value = 'value', 
         mean_sub1, mean_sub2, mean_sub3, mean_sub4, mean_gap) %>% 
  rename(ds = Date,
         y = value)  

# weekly
WeeklyMean <- yrs_2007tm2010 %>%
  group_by(Year, Month, Week) %>%
  summarise(mean_sub1 = mean(Sub_metering_1), 
            mean_sub2 = mean(Sub_metering_2),
            mean_sub3 = mean(Sub_metering_3),
            mean_sub4 = mean(Sub_metering_4),
            mean_gap = mean(GAP))

# monthly
MonthlyMean <- yrs_2007tm2010 %>%
  group_by(Year, Quarter, Month) %>%
  summarise(mean_sub1 = mean(Sub_metering_1), 
            mean_sub2 = mean(Sub_metering_2),
            mean_sub3 = mean(Sub_metering_3),
            mean_sub4 = mean(Sub_metering_4),
            mean_gap = mean(GAP))
# yearly
YearlyMean <- yrs_2007tm2010 %>%
  group_by(Year) %>%
  summarise(mean_sub1 = mean(Sub_metering_1), 
            mean_sub2 = mean(Sub_metering_2),
            mean_sub3 = mean(Sub_metering_3),
            mean_sub4 = mean(Sub_metering_4),
            mean_gap = mean(GAP))

# save my data ----
saveRDS(YearlyMean, file = 'data/YearlyMeanData.rds')
