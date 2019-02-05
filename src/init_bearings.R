# bearings function

library(doParallel)
library(plyr)

source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/marvin/rteu/field_test/data/")
s <- getEnvi("/home/marvin/rteu/field_test/scripts/")


# source bearing function
source(paste0(s$modified$here, "srvFileIO_reverse.R"))
source(paste0(s$modified$here, "srvFilters_reverse.R"))
source(paste0(s$modified$here, "srvDoA.R"))


ref <- read.csv(paste0(p$gps_data$here, "lut_measures.csv"), stringsAsFactors = FALSE)
ref$start <- as.POSIXct(ref$start, origin = "1970-01-01",tz = "UTC")
ref$end <- as.POSIXct(ref$end, origin = "1970-01-01",tz = "UTC")


# antenna locations
receiver_data <- read.csv(paste0(p$gps_data$here, "antennas.csv"))

# read all logger data
logger_data <- read_logger_folder(p$logger_data$log_fieldtest$here)
logger_data <- filter_data_freq(logger_data, freq = 150203, freq_error = 2)



match_bearings <- function(bearings, ref){
  bearings$id <- NA
  for(i in seq(nrow(ref))){
    bearings$id[which(bearings$timestamp > ref$start[i] & bearings$timestamp < ref$end[i])]  <- ref$id[i]
  }
  bearings <- join(bearings, ref, by = "id")
  
  # calculate angle error
  bearings$angle_error <- 0
  
  # min angle function
  min_angle <- function(a1, a2){
    180 - abs(abs(a1 - a2) - 180)
  }
  
  bearings$angle_error[bearings$Station == "S1"] <- min_angle(bearings$angle[bearings$Station == "S1"], bearings$bearing_s1[bearings$Station == "S1"])
  bearings$angle_error[bearings$Station == "S2"] <- min_angle(bearings$angle[bearings$Station == "S2"], bearings$bearing_s2[bearings$Station == "S2"])
  bearings$angle_error[bearings$Station == "S3"] <- min_angle(bearings$angle[bearings$Station == "S3"], bearings$bearing_s3[bearings$Station == "S3"])
  
  
  bearings$antennas <- as.factor(bearings$antennas)
  return(bearings)
  
}
