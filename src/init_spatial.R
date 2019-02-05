# rteu spatial init

library(rgdal)
library(mapview)
library(raster)
library(plyr)


source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/marvin/rteu/field_test/data/")
s <- getEnvi("/home/marvin/rteu/field_test/scripts/")





# antenna as spatial
antennas <- read.csv(paste0(p$gps_data$here, "antennas.csv"))

antennas <- antennas[c(1,5,9),]

scheme <- list(antennas = antennas)
coordinates(antennas) <- ~ Longitude + Latitude
projection(antennas) <- CRS("+proj=longlat +datum=WGS84")


# reference as spatial
ref <-  read.csv(paste0(p$gps_data$here, "lut_measures.csv"), stringsAsFactors = FALSE)
ref <- ref[ref$method == "RUHE",]

scheme$ref <- ref


coordinates(ref) <- ~ pos.X + pos.Y
projection(ref) <- CRS("+proj=longlat +datum=WGS84")

mapview(antennas) + mapview(ref)


scheme_sp <- list(antennas = antennas, ref = ref)
rm(antennas, ref)

