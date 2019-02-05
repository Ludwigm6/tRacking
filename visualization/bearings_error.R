# show bearing angle results
library(ggplot2)

source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/marvin/rteu/field_test/data/")
s <- getEnvi("/home/marvin/rteu/field_test/scripts/")


b <- readRDS(paste0(p$bearings$here, "bearings_calibration.RDS"))

# only ruhe points
b <- b[b$method == "RUHE",]


# bearings angle error ~ antennas
#-----------------------------------------------------

pdf(paste0(p$results$here, "bearings_antennas.pdf"), width = 8, height = 6)
ggplot(b[b$calibration == "yes",], aes(y = angle_error, group = antennas, x = antennas))+
  geom_boxplot()+
  scale_x_discrete(name = "Number of antennas per station", labels = c("1","2","3","4"))+
  scale_y_continuous(name = "Angle error [°]", breaks = seq(0,180,10))+
  theme(panel.background = element_blank(), panel.grid = element_line(color = "grey80"),
        panel.grid.major.x = element_blank())

dev.off()



# remove bearings with only 1 or 2 antennas
b <- b[as.numeric(b$antennas) > 1,]

# check what the calibration did
#----------------------------------------------
pdf(paste0(p$results$here, "bearings_station_calibration.pdf"), width = 8, height = 6)

ggplot(b, aes(y = angle_error, x = Station, fill = calibration))+
  geom_boxplot()+
  scale_fill_grey(start = 0.7, end = 1, guide = FALSE)+
  scale_x_discrete(name = NULL)+
  scale_y_continuous(name = "Angle error [°]", breaks = seq(0,180,10))+
  theme(panel.background = element_blank(), panel.grid = element_line(color = "grey80"),
        panel.grid.major.x = element_blank())

dev.off()


ggplot(b[b$calibration == "yes" & b$Station == "S3",], aes(y = angle_error, x = location))+
  geom_boxplot()



# different dbLOSS
#-----------------------------------------------------------

b <- readRDS(paste0(p$bearings$here, "bearings_dbloss.RDS"))

b <- b[b$method == "RUHE",]
b <- b[as.numeric(b$antennas) > 1,]

pdf(paste0(p$results$here, "bearings_dbloss.pdf"), width = 12, height = 6)
ggplot(b, aes(y = angle_error, x = dbloss, group = dbloss))+
  geom_boxplot()+
  scale_x_continuous(name = "db Loss", breaks = seq(1,25))+
  scale_y_continuous(name = "Angle error [°]", breaks = seq(0,180,10))+
    theme(panel.background = element_blank(), panel.grid = element_line(color = "grey80"),
          panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank())
dev.off()













