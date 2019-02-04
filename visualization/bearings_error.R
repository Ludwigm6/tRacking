# show bearing angle results
library(ggplot2)

source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/marvin/rteu/field_test/data/")
s <- getEnvi("/home/marvin/rteu/field_test/scripts/")


b <- read.csv(paste0(p$bearings$here, "bearings.csv"), stringsAsFactors = FALSE)
b$timestamp <- as.POSIXct(b$timestamp, tz = "UTC")

# remove WALK for now
b <- na.omit(b)
b <- b[b$method == "RUHE",]

# calculate angle error
b$angle_error <- 0

# min angle function
min_angle <- function(a1, a2){
  180 - abs(abs(a1 - a2) - 180)
}

b$angle_error[b$Station == "S1"] <- min_angle(b$angle[b$Station == "S1"], b$bearing_s1[b$Station == "S1"])
b$angle_error[b$Station == "S2"] <- min_angle(b$angle[b$Station == "S2"], b$bearing_s2[b$Station == "S2"])
b$angle_error[b$Station == "S3"] <- min_angle(b$angle[b$Station == "S3"], b$bearing_s3[b$Station == "S3"])


b$antennas <- as.factor(b$antennas)


# bearings angle error ~ antennas

pdf(paste0(p$results$here, "bearing_error_ruhe.pdf"), width = 10, height = 4)
ggplot(b, aes(y = angle_error, group = antennas, x = antennas))+
  geom_boxplot()+
  scale_x_discrete(name = "Antennas", labels = c("1","2","3","4"))+
  scale_y_continuous(name = "Angle difference [°]", expand = c(0.01,0.01))+
  theme_classic()+theme(panel.grid.minor = element_blank())+
  coord_flip()
dev.off()


# bearing angle error ~ station
# only with antennas > 1

pdf(paste0(p$results$here, "bearing_error_station.pdf"), width = 10, height = 4)
ggplot(b[b$Station != 1,], aes(y = angle_error, group = Station, x = Station))+
  geom_boxplot()+
  scale_x_discrete(name = "Station", labels = c("S1","S2","S3"))+
  scale_y_continuous(name = "Angle difference [°]", expand = c(0.01,0.01))+
  theme_classic()+theme(panel.grid.minor = element_blank())+
  coord_flip()
dev.off()




