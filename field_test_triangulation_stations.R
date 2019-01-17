# field test triangulation exclude stations

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



# unique combinations of stations
sc <- combn(unique(bearings$Station), m = 2)

# only bearings with 3 antenna signals
bearings <- subset(bearings, antennas >= 3)

for(i in seq(3)){
  b <- bearings[bearings$Station %in% sc[,i],]
  triangulations <- na.omit(triangulate(receiver_data, na.omit(b), 
                                        time_error_inter_station = 2,
                                        only_one = F,
                                        angles_allowed = c(50,100),
                                        tm_method = "tm",
                                        tri_option = "two_strongest",
                                        spar = 0.1, 
                                        progress = F))
  
  saveRDS(triangulations, paste0(p$triangulations$stations$here, "field_test_triangulation_s_", sc[1,i], "_", sc[2,i], ".RDS"))
  
  
}






