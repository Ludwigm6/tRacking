# distance from triangulation point to reference point
library(lubridate)


source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/hanna/rteu/data/")
s <- getEnvi("/home/hanna/rteu/scripts/")


tri <- readRDS(paste0(p$triangulations$here, "field_test_triangulation_a3.RDS"))
ref <- readRDS(paste0(p$reference_position$here, "field_test_reference_points.RDS"))



# test with rest1
# filter through timestamps

r1 <- tri[tri$timestamp > ref$start[1] & tri$timestamp < ref$end[1],]

r1sp <- r1
coordinates(r1sp) <- ~ pos.X + pos.Y
projection(r1sp) <- CRS("+proj=longlat +datum=WGS84")

refsp <- ref
coordinates(refsp) <- ~ pos.X + pos.Y
projection(refsp) <- CRS("+proj=longlat +datum=WGS84")


mapview(r1sp, color = "red") + mapview(refsp[1,])
