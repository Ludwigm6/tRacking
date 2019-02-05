# visualize triangulations

library(ggplot2)

source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/marvin/rteu/field_test/data/")
s <- getEnvi("/home/marvin/rteu/field_test/scripts/")



t <- readRDS(paste0(p$triangulations$here, "tri_minimal_angles.RDS"))
l <- table(t$min_angle)


pdf(paste0(p$results$here, "triangulation_min_angle.pdf"), width = 12, height = 6)
ggplot(t, aes(y = refdist, group = min_angle, x = min_angle))+
  geom_boxplot()+
  scale_x_continuous(name = "Minimal angle allowed [°]", breaks = seq(0,160,10),
                     sec.axis = dup_axis(name = "Available Points", labels = l))+
  scale_y_continuous(name = "Distance error [m]", breaks = seq(0,400,20))+
  theme(panel.background = element_blank(), panel.grid = element_line(color = "grey80"),
        panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank())
dev.off()

t <- readRDS(paste0(p$triangulations$here, "tri_maximal_angles.RDS"))
l <- table(t$max_angle)

pdf(paste0(p$results$here, "triangulation_max_angle.pdf"), width = 12, height = 6)
ggplot(t, aes(y = refdist, group = max_angle, x = max_angle))+
  geom_boxplot()+
  scale_x_continuous(name = "Maximal angle allowed [°]", breaks = seq(50,180,10),
                     sec.axis = dup_axis(name = "Available points", labels = l))+
  scale_y_continuous(name = "Distance error [m]", breaks = seq(0,400,20))+
  theme(panel.background = element_blank(), panel.grid = element_line(color = "grey80"),
        panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank())
dev.off()





