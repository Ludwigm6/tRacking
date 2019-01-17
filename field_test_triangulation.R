# own attempt at bat trinagulation with field test
library(rgdal)
library(readxl)
library(doParallel)

source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/hanna/rteu/data/")
s <- getEnvi("/home/hanna/rteu/scripts/")


# load bearings
bearings <- readRDS(paste0(p$bearings$here, "field_test_bearings.RDS"))
receiver_data <- read_xlsx(paste0(p$logger_data_feldtest$here, "Antennas_feld.xlsx"))


# load some functions from the actual rteu server package:
#----------------------------------------------------------username
source(paste0(s$logger_app$server$here, "srvDoA.R"))
source(paste0(s$logger_app$server$here, "srvTriangulation.R"))
source(paste0(s$here, "srvMapFuncs_modified.R"))
source(paste0(s$here, "srvTabBearings_modified.R"))
source(paste0(s$here, "compare_funs.R"))

# triangulation with different bearing qualities (based on antenna number)
#-----------------------------------------------------------------------------
for(i in seq(4)){
  b <- subset(bearings, antennas >= i)
  triangulations <- na.omit(triangulate(receiver_data, na.omit(b), 
                                        time_error_inter_station = 2,
                                        only_one = F,
                                        angles_allowed = c(30,150),
                                        tm_method = "tm",
                                        tri_option = "two_strongest",
                                        spar = 0.1, 
                                        progress = F))
  saveRDS(triangulations, paste0(p$triangulations$antennas$here, "field_test_triangulation_a", i, ".RDS"))
}


# triangulation with different allowed min angles
#-----------------------------------------------------
b <- subset(bearings, antennas >= 3)
for(i in seq(10,170,10)){
  triangulations <- na.omit(triangulate(receiver_data, na.omit(b), 
                                        time_error_inter_station = 2,
                                        only_one = F,
                                        angles_allowed = c(i,180),
                                        tm_method = "tm",
                                        tri_option = "two_strongest",
                                        spar = 0.1, 
                                        progress = F))
  saveRDS(triangulations, paste0(p$triangulations$min_angle$here, "field_test_triangulation_min_angle_", sprintf("%03i",i), ".RDS"))
  
}

# triangulation with different allowed max angles
#-----------------------------------------------------
b <- subset(bearings, antennas >= 3)

for(i in seq(20,180,10)){
  triangulations <- na.omit(triangulate(receiver_data, na.omit(b), 
                                        time_error_inter_station = 2,
                                        only_one = F,
                                        angles_allowed = c(10,i),
                                        tm_method = "tm",
                                        tri_option = "two_strongest",
                                        spar = 0.1, 
                                        progress = F))
  saveRDS(triangulations, paste0(p$triangulations$max_angle$here, "field_test_triangulation_max_angle_", sprintf("%03i",i), ".RDS"))
  
}

# triangulation with different max angles and min angle = 40
b <- subset(bearings, antennas >= 3)

for(i in seq(50,180,10)){
  triangulations <- na.omit(triangulate(receiver_data, na.omit(b), 
                                        time_error_inter_station = 2,
                                        only_one = F,
                                        angles_allowed = c(40,i),
                                        tm_method = "tm",
                                        tri_option = "two_strongest",
                                        spar = 0.1, 
                                        progress = F))
  saveRDS(triangulations, paste0(p$triangulations$max_angle_min40$here, "field_test_triangulation_min40_max_angle_", sprintf("%03i",i), ".RDS"))
  
}



