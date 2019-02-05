
source("/home/marvin/rteu/field_test/scripts/tRacking/src/init_bearings.R")


# calibration or no calibration
#--------------------------------------

calib <- read.csv(paste0(p$logger_data$here, "calibrations.csv"))

logger_calib <- logger_data
logger_calib <- join(logger_calib, calib, by = "receiver")
logger_calib$max_signal <- logger_calib$max_signal + logger_calib$correction


bearings_cal <- lapply(list(logger_data, logger_calib), function(l){
  # calculate all bearings
  tm_signals <- time_match_signals(l, station_time_error = 0.3)
  
  
  # bearings with 14 dbLoss
  # dBLoss -> signal difference to same antenna rotated 90 degree
  registerDoParallel(cores=detectCores())
  bearings <- doa(tm_signals, receiver_data, dBLoss = 14)
  bearings$timestamp <- as.POSIXct(bearings$timestamp, origin = "1970-01-01", tz = "UTC")
  stopImplicitCluster()
  bearings <- match_bearings(bearings, ref)
  bearings <- na.omit(bearings)
  return(bearings)
})

bearings_cal_test <- do.call(rbind, bearings_cal)
bearings_cal_test$calibration <- c(rep("no", 6852), rep("yes", 6760))

saveRDS(bearings_cal_test, paste0(p$bearings$here, "bearings_calibration.RDS"))


# continue with calibrated bearings
#------------------------------------------
# test different dBLosses
bearings_loss <- lapply(seq(1,25,1), function(j){
  tm_signals <- time_match_signals(logger_calib, station_time_error = 0.3)
  registerDoParallel(cores=detectCores())
  bearings <- doa(tm_signals, receiver_data, dBLoss = j)
  bearings$timestamp <- as.POSIXct(bearings$timestamp, origin = "1970-01-01", tz = "UTC")
  stopImplicitCluster()
  
  bearings <- match_bearings(bearings, ref)
  bearings <- na.omit(bearings)
  bearings$dbloss <- j
  return(bearings)
  
})

bearings_loss_test <- do.call(rbind, bearings_loss)

boxplot(bearings_cal_test$angle_error[bearings_cal_test$method != "WALK"] ~ bearings_cal_test$calibration[bearings_cal_test$method != "WALK"])

saveRDS(bearings_loss_test, paste0(p$bearings$here, "bearings_dbloss.RDS"))

# final bearings with calibration and 15 dbLoss
#---------------------------------------
tm_signals <- time_match_signals(logger_calib, station_time_error = 0.3)
registerDoParallel(cores=detectCores())
bearings <- doa(tm_signals, receiver_data, dBLoss = 15)
bearings$timestamp <- as.POSIXct(bearings$timestamp, origin = "1970-01-01", tz = "UTC")
stopImplicitCluster()

bearings <- match_bearings(bearings, ref)
bearings <- na.omit(bearings)

saveRDS(bearings, paste0(p$bearings$here, "bearings.RDS"))





