# plots for triangulation error

library(lubridate)
library(raster)
library(mapview)
library(plyr)
library(ggplot2)
library(viridis)



source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/hanna/rteu/data/")
s <- getEnvi("/home/hanna/rteu/scripts/")

# function for calculating distance from tri point to matching ref point
source(paste0(s$tRacking$here, "field_test_distance.R"))

# stations and reference points
stations <- readRDS(paste0(p$logger_data_feldtest$here, "stations.RDS"))
reference <- readRDS(paste0(p$reference_position$here, "field_test_reference_points.RDS"))


# different min angle
#------------------------------
tri_mina <- lapply(list.files(p$triangulations$min_angle$here, full.names = TRUE, pattern = ".RDS$"), readRDS)
tri_mina <- lapply(tri_mina, function(x){ref_distance(x,reference)})
for(i in seq(length(tri_mina))){tri_mina[[i]]$angle <- i}
tri_mina <- do.call(rbind, tri_mina)
tri_mina$angle <- as.factor(tri_mina$angle)

pdf(paste0(p$results$here, "minimum_angle.pdf"), width = 12, height = 8)
ggplot(tri_mina, aes(angle, refdist))+
  geom_boxplot(outlier.size = 1, outlier.alpha = 0.5)+
  scale_x_discrete(name = "Smallest angle allowed [degree]", labels = seq(10,170,10))+
  scale_y_continuous(name = "Distance error [m]", breaks = seq(0,250,50), limits = c(0,250), expand = c(0,0))+
  theme(panel.grid.major.x = element_blank())
dev.off()


# different max angles
#------------------------------------------
tri_maxa <- lapply(list.files(p$triangulations$max_angle$here, full.names = TRUE, pattern = ".RDS$"), readRDS)
tri_maxa <- lapply(tri_maxa, function(x){ref_distance(x,reference)})
for(i in seq(length(tri_maxa))){tri_maxa[[i]]$angle <- i}
tri_maxa <- do.call(rbind, tri_maxa)
tri_maxa$angle <- as.factor(tri_maxa$angle)

ggplot(tri_maxa, aes(angle, refdist))+
  geom_boxplot(outlier.size = 1, outlier.alpha = 0.5)+
  scale_x_discrete(name = "Smallest angle allowed [degree]", labels = seq(20,180,10))+
  scale_y_continuous(name = "Distance error [m]", breaks = seq(0,1000,100), limits = c(0,1000), expand = c(0,0))+
  theme(panel.grid.major.x = element_blank())




# different max angle and min angle set to 40
#------------------------------------------
tri_maxa <- lapply(list.files(p$triangulations$max_angle_min40$here, full.names = TRUE, pattern = ".RDS$"), readRDS)
tri_maxa <- lapply(tri_maxa, function(x){ref_distance(x,reference)})
for(i in seq(length(tri_maxa))){tri_maxa[[i]]$angle <- i}
tri_maxa <- do.call(rbind, tri_maxa)
tri_maxa$angle <- as.factor(tri_maxa$angle)


pdf(paste0(p$results$here, "maximum_angle_min40.pdf"), width = 12, height = 8)
ggplot(tri_maxa, aes(angle, refdist))+
  geom_boxplot(outlier.size = 1, outlier.alpha = 0.5)+
  scale_x_discrete(name = "Smallest angle allowed [degree]", labels = seq(50,180,10))+
  scale_y_continuous(name = "Distance error [m]", breaks = seq(0,250,100), limits = c(0,250), expand = c(0,0))+
  theme(panel.grid.major.x = element_blank())
dev.off()


# different stations
#-----------------------------------





# TRASH
#-.-.--.-.-.-..-.-.-.-..-.-.


ggplot(stations, aes(x = pos.utm.X, y = pos.utm.Y))+
  geom_point(size = 4)+
  geom_point(data = ref, color = "red")+
  geom_point(data = tris[tris$refpoint == "2_2r",], mapping = aes(color = refdist), size = 0.8)+
  scale_color_gradientn(colors = viridis(15, direction = -1))+
  coord_equal()

ggplot(tri[tri$refpoint == "1_2r",], aes(x = pos.utm.X, y = pos.utm.Y, col = refdist))+
  geom_point()+
  scale_color_gradientn(colors = viridis(10, direction = -1))+
  geom_point(data = ref, mapping = aes(x = pos.utm.X, y = pos.utm.Y), color = "red")+
  scale_x_continuous(limits = c(474600, 475400))+
  scale_y_continuous(limits = c(5632000, 5632600))+
  coord_equal()
hist(tri$refdist)

ggplot(tri, aes(x = refpoint, y = refdist))+
  geom_boxplot()
