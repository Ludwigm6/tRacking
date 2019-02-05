# visualization of the field test method

library(ggplot2)
library(readxl)
library(rgdal)
library(raster)
library(mapview)

source("/home/marvin/rteu/field_test/scripts/tRacking/src/init_spatial.R")




# reference points
rf <- scheme$ref

# antennas
st <- scheme$antennas

dist_segment <- data.frame(seg = c("200m"), x = st$pos.utm.X[c(1)], y = st$pos.utm.Y[c(1)],
                           xend = st$pos.utm.X[c(2)], yend = st$pos.utm.Y[c(2)])



tiff(paste0(p$results$here, "field_test_scheme.tiff"), width = 600, height = 600)

ggplot(st, aes(Longitude, Latitude))+
  #geom_point(shape = 2, size = 3)+
  geom_text(aes(label = Station))+
  geom_point(data = rf, size = 3, mapping = aes(pos.X, pos.Y))+
  #geom_segment(data = dist_segment, aes(x = x+6, y = y+6, xend = xend+6, yend = yend+6),
   #            arrow = arrow(ends = "both", angle = 90, length = unit(0.2, "cm")))+
  #geom_text(data = dist_segment, aes(x = (x+xend)/2+11, y = (y+yend)/2+11, label = seg), angle = -52)+
  scale_x_continuous(name = "Latitude UTM [m]")+
  scale_y_continuous(name = "Longitude UTM [m]")+
  theme(panel.background = element_rect(fill = "grey95"),
        panel.grid = element_line(color = "grey80"))+
  coord_equal()

dev.off()

