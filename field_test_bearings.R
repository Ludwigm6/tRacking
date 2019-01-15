# raw logger data to bearings
source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/hanna/rteu/data/")
s <- getEnvi("/home/hanna/rteu/scripts/")

# required libraries:
library(readxl)
library(doParallel)

# Frequency of interest - FOI
FOI <- 150297

# load receiver tables
receiver_data <- read_excel(paste0(p$logger_data_feldtest$here, "Antennas_feld.xlsx"))


# load logger data
# load reverse engeneered scripts from the logger app:
# TODO: write real functions for some parts
#------------------------------------------------------------
source(paste0(s$here, "srvFileIO_reverse.R"))
source(paste0(s$here, "srvFilters_reverse.R"))

logger_data <- read_logger_folder(p$logger_data_feldtest$here)
logger_data$timestamp <- as.POSIXct(logger_data$timestamp, origin = "1970-01-01", tz = "UTC")

logger_data <- filter_data_freq(logger_data, freq = FOI, freq_error = 2)

# remove station 9 from logger data
logger_data <- logger_data[logger_data$Name != "fehler_9",]



# load some functions from the actual rteu server package:
#----------------------------------------------------------
source(paste0(s$logger_app$server$here, "srvDoA.R"))

# time match signals
# station_time_error = maximal error between two stations
tm_signals <- time_match_signals(logger_data, station_time_error = 1)

# calculate bearings
# dBLoss -> signal difference to same antenna rotated 90 degree
registerDoParallel(cores=detectCores())
bearings <- doa(tm_signals, receiver_data, dBLoss = 17)
bearings$timestamp <- as.POSIXct(bearings$timestamp, origin = "1970-01-01", tz = "UTC")
stopImplicitCluster()

saveRDS(bearings, paste0(p$bearings$here, "field_test_bearings.RDS"))

