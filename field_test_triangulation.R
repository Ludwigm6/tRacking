# own attempt at bat trinagulation with field test
library(rgdal)

source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/hanna/rteu/data/")
s <- getEnvi("/home/hanna/rteu/scripts/")


# load bearings
bearings <- readRDS(paste0(p$bearings$here, "field_test_bearings.RDS"))

# load some functions from the actual rteu server package:
#----------------------------------------------------------
source(paste0(s$logger_app$server$here, "srvDoA.R"))
source(paste0(s$logger_app$server$here, "srvTriangulation.R"))
source(paste0(s$here, "srvMapFuncs_modified.R"))
source(paste0(s$here, "srvTabBearings_modified.R"))
source(paste0(s$here, "compare_funs.R"))

# triangulation with different bearing qualities (based on antenna number)

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
  saveRDS(triangulations, paste0(p$triangulations$here, "field_test_triangulation_a", i, ".RDS"))
}

 