# bearings function
receiver_data <- read.csv(paste0(p$reference_points$here, "antennas.csv"))
logger_data <- read_logger_folder(p$logger_data$log_fieldtest$here)
logger_data$timestamp <- as.POSIXct(logger_data$timestamp, origin = "1970-01-01", tz = "UTC")

calc_bearings <- function(logger_data, receiver_data, function_path, FOI = 150203){
  library(doParallel)
  source(paste0(function_path, "srvFileIO_reverse.R"))
  source(paste0(function_path, "srvFilters_reverse.R"))
  source(paste0(function_path, "srvDoA.R"))
  
  # filter frequency
  logger_data <- filter_data_freq(logger_data, freq = FOI, freq_error = 2)
  
  
  
  
  # time match signals
  # station_time_error = maximal error between two stations
  tm_signals <- time_match_signals(logger_data, station_time_error = 1)
  
  
  # calculate bearings
  # dBLoss -> signal difference to same antenna rotated 90 degree
  registerDoParallel(cores=detectCores())
  bearings <- doa(tm_signals, receiver_data, dBLoss = 17)
  bearings$timestamp <- as.POSIXct(bearings$timestamp, origin = "1970-01-01", tz = "UTC")
  stopImplicitCluster()
  
  return(bearings)
  
}

