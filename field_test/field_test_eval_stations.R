library(rgdal)
library(readxl)
library(doParallel)

source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/hanna/rteu/data/")
s <- getEnvi("/home/hanna/rteu/scripts/")


source(paste0(s$tRacking$field_test$here, "field_test_distance.R"))

reference <- readRDS(paste0(p$reference_position$here, "field_test_reference_points.RDS"))

stations <- lapply(list.files(p$triangulations$stations$here, full.names = TRUE, pattern = "all_angles"), readRDS)

s1.3 <- stations[[1]]
s1.4 <- stations[[2]]
s3.4 <- stations[[3]]


s1.3 <- ref_distance(s1.3, reference)
s1.4 <- ref_distance(s1.4, reference)
s3.4 <- ref_distance(s3.4, reference)

s1.3 <- s1.3[s1.3$method == "r",]
s1.4 <- s1.4[s1.4$method == "r",]
s3.4 <- s3.4[s3.4$method == "r",]

boxplot(s1.3$refdist ~ s1.3$refpoint, ylim = c(0,200))
boxplot(s1.4$refdist ~ s1.4$refpoint, ylim = c(0,200))
boxplot(s3.4$refdist ~ s3.4$refpoint)

plot(s3.4$pos.utm.X, s3.4$pos.utm.Y)
