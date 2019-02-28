# DESCRIPTION: IoT, Smart Homes and Sub-meters
# NAME: Else 
# SCRIPT FUNCITON: Download selected columns from database by MySQL
# VERSION: 1

library("dplyr")
library("tidyr")
library("RMySQL")
library("lubridate")
library("fracdiff")
library("fpp2")
library("plotly")
library("ggfortify")
library("forecast")
library("stats")
library("prophet")
library("prettyunits")

# set working directory
setwd("/Users/else/Google Drive/BSSA - data analytics/Module 3/T1 - IoT/IoT")

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
