# field test station formating
library(readxl)

source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/hanna/rteu/data/")
s <- getEnvi("/home/hanna/rteu/scripts/")

source(paste0(s$here, "srvMapFuncs_modified.R"))

stations <- read_xlsx(paste0(p$logger_data_feldtest$here, "Antennas_feld.xlsx"))
stations$pos.utm.X <- wgstoutm(stations$Longitude, stations$Latitude)[,1]
stations$pos.utm.Y <- wgstoutm(stations$Longitude, stations$Latitude)[,2]

colnames(stations) <- c("name", "station", "pos.X", "pos.Y", "orientation", "beam.width", "pos.utm.X", "pos.utm.Y")
saveRDS(stations, paste0(p$logger_data_feldtest$here, "stations.RDS"))
