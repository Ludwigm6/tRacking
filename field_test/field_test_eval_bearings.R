# bearing angle evaluation

library(rgdal)
library(readxl)
library(doParallel)

source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/hanna/rteu/data/")
s <- getEnvi("/home/hanna/rteu/scripts/")

bearings <- readRDS(paste0(p$bearings$here, "field_test_bearings.RDS"))
reference <- readRDS(paste0(p$reference_position$here, "field_test_reference_points.RDS"))


# only motionless points for now
reference <- reference[reference$method == "r",]

# match time stamp
bearings$refpoint <- NA
bearings$method <- NA

for(i in seq(nrow(reference))){
  bearings$refpoint[which(bearings$timestamp > reference$start[i] & bearings$timestamp < reference$end[i])] <- reference$name[i]
  bearings$method[which(bearings$timestamp > reference$start[i] & bearings$timestamp < reference$end[i])] <- reference$method[i]
}

bearings <- na.omit(bearings)


# calculate angle difference
stationLUT <- data.frame(station = c("fehler_1", "fehler_3", "fehler_4"),
                         column = c(12,13,14))

bearings$anglediff <- 0
for(j in seq(nrow(bearings))){
  bearings$anglediff[j] <- bearings$angle[j] - reference[which(reference$name == bearings$refpoint[j]),
                                                         stationLUT$column[which(stationLUT$station == bearings$Station[j])]]
}

saveRDS(bearings, paste0(p$bearings$here, "eval_bearings.RDS"))


