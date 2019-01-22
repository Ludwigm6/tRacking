# visualization of the field test method

library(ggplot2)
library(readxl)
library(rgdal)
library(raster)
library(mapview)

source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/hanna/rteu/data/")



# reference points
rf <- readRDS(paste0(p$reference_position$here, "field_test_reference_points.RDS"))
rf <- rf[rf$method == "r",]


# antennas
st <- readRDS(paste0(p$logger_data_feldtest$here, "stations.RDS"))
st <- st[c(1,5,9,13),]
st$name <- c(paste0("S", seq(4)))

dist_segment <- data.frame(seg = c("200m"), x = st$pos.utm.X[c(1)], y = st$pos.utm.Y[c(1)],
                           xend = st$pos.utm.X[c(2)], yend = st$pos.utm.Y[c(2)])



mapview(st, color = "red") + mapview(rf)

tiff(paste0(p$results$here, "field_test_scheme.tiff"), width = 600, height = 600)

ggplot(st, aes(pos.utm.X, pos.utm.Y))+
  geom_point(shape = 2, size = 3)+
  geom_text(aes(label = name), nudge_x = -8)+
  geom_point(data = rf, size = 3)+
  geom_segment(data = dist_segment, aes(x = x+6, y = y+6, xend = xend+6, yend = yend+6),
               arrow = arrow(ends = "both", angle = 90, length = unit(0.2, "cm")))+
  geom_text(data = dist_segment, aes(x = (x+xend)/2+11, y = (y+yend)/2+11, label = seg), angle = -52)+
  scale_x_continuous(name = "Latitude UTM [m]", expand = c(0,0), limits = c(474800, 475150))+
  scale_y_continuous(name = "Longitude UTM [m]", expand = c(0,0), limits = c(5632100, 5632450))+
  theme(panel.background = element_rect(fill = "grey95"),
        panel.grid = element_line(color = "grey80"))+
  coord_equal()

dev.off()

