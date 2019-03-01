###############################################################################
#                                                                             #
#   DESCRIPTION: IoT, Smart Homes and Sub-meters                              #
#   SCRIPT FUNCITON:                                                          #
#   Combine tables, date & time, create attributes and subset daily averages  #
#   Version: 2                                                                #
#   NAME: Else                                                                #
#                                                                             #
###############################################################################

# get the data ----
yrs_2007tm2010 <- readRDS(file = 'data/totalData.rds')

# Combine tables into one dataframe using dplyr ----
yrs_2007tm2010 <- bind_rows(yr_2007SELECT, 
                            yr_2008SELECT,
                            yr_2009SELECT,
                            yr_2010SELECT)

# Combine Date and Time attribute values in a new attribute column ----
yrs_2007tm2010 <-cbind(yrs_2007tm2010,
                       paste(yrs_2007tm2010$Date,yrs_2007tm2010$Time), 
                       stringsAsFactors=FALSE)

# Give the new attribute in the 8th column a header name 
colnames(yrs_2007tm2010)[7] <-"DateTime"

# Move the DateTime attribute within the dataset
yrs_2007tm2010 <- yrs_2007tm2010[, c(ncol(yrs_2007tm2010),
                                     1:(ncol(yrs_2007tm2010)-1))]

# Convert DateTime from POSIXlt to POSIXct 
yrs_2007tm2010$DateTime <- as.POSIXct(yrs_2007tm2010$DateTime, 
                                      "%Y/%m/%d %H:%M:%S")

# Add the time zone
attr(yrs_2007tm2010$DateTime, "tzone") <- "Europe/Paris"

# Add additional attributes extracted from DateTime ----
# Create attributes for: 
# year, quarter, month, week, weekday, day, hour and minute
yrs_2007tm2010$Year <- year(yrs_2007tm2010$DateTime)
yrs_2007tm2010$Quarter <- quarter(yrs_2007tm2010$DateTime)
yrs_2007tm2010$Month <- month(yrs_2007tm2010$DateTime)
yrs_2007tm2010$Week <- week(yrs_2007tm2010$DateTime)
yrs_2007tm2010$Weekday <- weekdays(yrs_2007tm2010$DateTime)
yrs_2007tm2010$Day <- day(yrs_2007tm2010$DateTime)
yrs_2007tm2010$Hour <- hour(yrs_2007tm2010$DateTime)
yrs_2007tm2010$Minute <- minute(yrs_2007tm2010$DateTime)


# Add attribute GAP and sub meter 4 based from other attributes ----
yrs_2007tm2010 <- mutate(yrs_2007tm2010, 
                         GAP = Global_active_power*1000/60)
yrs_2007tm2010 <- mutate(yrs_2007tm2010, 
                         Sub_metering_4 = GAP - (Sub_metering_1 + 
                                                   Sub_metering_2 + 
                                                   Sub_metering_3))

# Turn attribute Date into date instead of character
yrs_2007tm2010$Date <- date(yrs_2007tm2010$Date)

# check for missing data
yrs_2007tm2010[!complete.cases(yrs_2007tm2010),] 

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

