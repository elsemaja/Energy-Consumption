###############################################################################
#                                                                             #
#   DESCRIPTION: IoT, Smart Homes and Sub-meters                              #
#   SCRIPT FUNCITON: get and prepare the whole data for shiny app             #
#   Combine tables, date & time, create attributes and subset daily averages  #
#   Version: 2                                                                #
#   NAME: Else                                                                #
#                                                                             #
###############################################################################

# libraries ----
if (require(pacman) == FALSE) {
  install.packages('pacman')
}

pacman::p_load(RMySQL, lubridate, dplyr)

# import data from SQL ----
# Create a database connection 
con = dbConnect(MySQL(), 
                user='deepAnalytics', 
                password='Sqltask1234!', 
                dbname='dataanalytics2018', 
                host='data-analytics-2018.cbrosir2cswx.us-east-1.rds.amazonaws.com')

# List the tables contained in the database 
dbListTables(con)

# Lists attributes contained in the yr_2006 table
dbListFields(con,'yr_2006')

# Use asterisk " * " to select all attributes for download
# Use attribute "names" to select specific attributes for download
yr_2006SELECT <- dbGetQuery(con, 
                            "SELECT Date, 
                            Time, 
                            Sub_metering_1, 
                            Sub_metering_2, 
                            Sub_metering_3,
                            Global_active_power FROM yr_2006")
yr_2007SELECT <- dbGetQuery(con, 
                            "SELECT Date, 
                            Time, 
                            Sub_metering_1, 
                            Sub_metering_2, 
                            Sub_metering_3,
                            Global_active_power FROM yr_2007")
yr_2008SELECT <- dbGetQuery(con, 
                            "SELECT Date, 
                            Time, 
                            Sub_metering_1, 
                            Sub_metering_2, 
                            Sub_metering_3,
                            Global_active_power FROM yr_2008")
yr_2009SELECT <- dbGetQuery(con, 
                            "SELECT Date, 
                            Time, 
                            Sub_metering_1, 
                            Sub_metering_2, 
                            Sub_metering_3,
                            Global_active_power FROM yr_2009")
yr_2010SELECT <- dbGetQuery(con, 
                            "SELECT Date, 
                            Time, 
                            Sub_metering_1, 
                            Sub_metering_2, 
                            Sub_metering_3,
                            Global_active_power FROM yr_2010")

# Data cleaning and pre-processing ----

# Combine tables into one dataframe using dplyr ----
yrs_2007tm2010 <- bind_rows(yr_2007SELECT, 
                            yr_2008SELECT,
                            yr_2009SELECT,
                            yr_2010SELECT)

# cleaning the environment 
rm(yr_2006SELECT, yr_2007SELECT, yr_2008SELECT, yr_2009SELECT, yr_2010SELECT, con)


# Combine Date and Time attribute values in a new attribute column ----
yrs_2007tm2010 <-cbind(yrs_2007tm2010,
                       'DateTime' = paste(yrs_2007tm2010$Date,yrs_2007tm2010$Time), 
                       stringsAsFactors=FALSE)

# Move the DateTime attribute within the dataset by selecting the last column, 
# move it to the first place and add the rest of the 4 columns after it.
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

# save my data ----
saveRDS(yrs_2007tm2010, file = 'data/totalData.rds')
