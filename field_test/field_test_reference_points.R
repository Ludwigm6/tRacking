# field test reference points
source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/hanna/rteu/data/")
s <- getEnvi("/home/hanna/rteu/scripts/")

library(rgdal)
library(geosphere)
library(raster)
source(paste0(s$here, "compare_funs.R"))
source(paste0(s$here, "srvMapFuncs_modified.R"))

refpos <- shapefile(paste0(p$reference_position$here, "Position.shp"))

# only field data
refpos <- refpos[-c(1:18),]
refpos <- refpos[1:17,]


# some additional data conversation etc.
refpos@data$date <- "2018-11-29"
refpos@data$timestamp <- as.POSIXct(paste(refpos@data$date, refpos@data$Zeit), format = "%Y-%m-%d %H:%M:%S", tz = "CET") + hrs(2)
refpos <- spTransform(refpos, CRS("+proj=longlat +datum=WGS84"))

pos <- as.data.frame(refpos)
colnames(pos)[1] <- "time"
colnames(pos)[5:6] <- c("pos.X", "pos.Y")
pos$pos.utm.X <- wgstoutm(pos$pos.X, pos$pos.Y)[,1]
pos$pos.utm.Y <- wgstoutm(pos$pos.X, pos$pos.Y)[,2]


# add time stamps for each reference point
pos$start <- pos$timestamp-mns(2)
pos$end <- pos$timestamp

# add method marker (r = rest, m = moving)
pos$method <- "r"
pos$method[grepl("m", pos$name)] <- "m"

# add angles to each station
stations <- readRDS(paste0(p$logger_data_feldtest$here, "stations.RDS"))
stations <- stations[c(1,5,9,13),]

# function for bearing angle as the dfference from north, clockwise







saveRDS(pos, paste0(p$reference_position$here, "field_test_reference_points.RDS"))

