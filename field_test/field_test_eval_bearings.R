# bearing angle evaluation

library(rgdal)
library(readxl)
library(doParallel)

source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/hanna/rteu/data/")
s <- getEnvi("/home/hanna/rteu/scripts/")

bearings <- readRDS(paste0(p$bearings$here, "field_test_bearings.RDS"))
reference <- readRDS(paste0(p$reference_position$here, "field_test_reference_points.RDS"))



boxplot(bearings$angle ~ bearings$Station)

