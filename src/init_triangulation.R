# init triangulation
library(rgdal)
library(mapview)
library(raster)
library(plyr)


source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/marvin/rteu/field_test/data/")
s <- getEnvi("/home/marvin/rteu/field_test/scripts/")


source(paste0(s$logger_app$server$here, "srvDoA.R"))
source(paste0(s$logger_app$server$here, "srvTriangulation.R"))
source(paste0(s$modified$here, "srvMapFuncs_modified.R"))
source(paste0(s$modified$here, "srvTabBearings_modified.R"))

# load and format bearings
bearings <- readRDS(paste0(p$bearings$here, "bearings.RDS"))
bearings$timestamp <- as.POSIXct(bearings$timestamp, tz = "UTC")
bearings$start <- as.POSIXct(bearings$start, tz = "UTC")
bearings$end <- as.POSIXct(bearings$end, tz = "UTC")
bearings <- na.omit(bearings)


# load and format receiver data
receiver_data <- read.csv(paste0(p$gps_data$here, "antennas.csv"))
ref <-  read.csv(paste0(p$gps_data$here, "lut_measures.csv"), stringsAsFactors = FALSE)
ref$start <- as.POSIXct(ref$start, tz = "UTC")
ref$end <- as.POSIXct(ref$end, tz = "UTC")



# functions
#---------------------------

# turn triangulations into spatial object
tri_sp <- function(tri){
  trisp <- tri
  coordinates(trisp) <- ~ pos.X + pos.Y
  projection(trisp) <- CRS("+proj=longlat +datum=WGS84")
  return(trisp)
}

# match time stamps and join triangulation points with reference points
tri_match <- function(tri, ref){
  ct <- colnames(tri)
  tri$id <- NA
  for(i in seq(nrow(ref))){
    tri$id[which(tri$timestamp > ref$start[i] & tri$timestamp < ref$end[i])] <- ref$id[i]
  }
  tri <- join(tri, ref, by = "id")
  colnames(tri) <- paste0("r_", colnames(tri))
  colnames(tri)[1:length(ct)] <- ct
  return(tri)
}

# calculate distance between gps point and triangulation point
tri_error <- function(tri){
  tri$refdist <- 0
  for(j in seq(nrow(tri))){
    tri$refdist[j] <- pointDistance(c(tri$pos.utm.X[j], tri$pos.utm.Y[j]),
                                    c(tri$r_pos.utm.X[j], tri$r_pos.utm.Y[j]), lonlat = FALSE)
  }
  return(tri)
}






