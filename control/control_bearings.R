


source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/marvin/rteu/field_test/data/")
s <- getEnvi("/home/marvin/rteu/field_test/scripts/")


# source bearing function
source(paste0(s$tRacking$src$here, "calc_bearings.R"))
source(paste0(s$modified$here, "srvFileIO_reverse.R"))
source(paste0(s$modified$here, "srvFilters_reverse.R"))


# antenna locations
receiver_data <- read.csv(paste0(p$gps_data$here, "antennas.csv"))

# read all logger data
logger_data <- read_logger_folder(p$logger_data$log_fieldtest$here)

# calculate all bearings
b <- calc_bearings(logger_data = logger_data,
                   receiver_data = receiver_data,
                   function_path = s$modified$here,
                   FOI = 150203)


# add reference point information
ref <- read.csv(paste0(p$gps_data$here, "lut_measures.csv"), stringsAsFactors = FALSE)
ref$start <- as.POSIXct(ref$start, origin = "1970-01-01",tz = "UTC")
ref$end <- as.POSIXct(ref$end, origin = "1970-01-01",tz = "UTC")


b$id <- NA
for(i in seq(nrow(ref))){
  b$id[which(b$timestamp > ref$start[i] & b$timestamp < ref$end[i])]  <- ref$id[i]
}


b <- na.omit(b)
write.csv(b, paste0(p$bearings$here, "bearings.csv"), row.names = FALSE)


