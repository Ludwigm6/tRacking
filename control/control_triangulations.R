# triangulation function

source("~/rteu/field_test/scripts/tRacking/src/init_triangulation.R")

# filter bearings
bearings <- bearings[as.numeric(bearings$antennas) > 1,]
bearings <- bearings[bearings$method %in% c("RUHE"),]


# try different minimal angles
#------------------------------------------------------

tri_min_angle <- lapply(seq(0,160,10), function(i){
  
  tri <- triangulate(receiver_data, bearings, 
                     time_error_inter_station = 0.5,
                     only_one = F,
                     angles_allowed = c(i,170),
                     tm_method = "tm",
                     tri_option = "two_strongest",
                     progress = F)
  tri <- na.omit(tri)
  tri <- tri_match(tri, ref)
  tri <- tri_error(tri)
  tri$min_angle <- i
  return(tri)
  
})

tri_min_angle <- do.call(rbind, tri_min_angle)

saveRDS(tri_min_angle, paste0(p$triangulations$here, "tri_minimal_angles.RDS"))


# try different maximum angles, minimum set to 40
#----------------------------------------------------

tri_max_angle <- lapply(seq(50,180,10), function(i){
  
  tri <- triangulate(receiver_data, bearings, 
                     time_error_inter_station = 0.5,
                     only_one = F,
                     angles_allowed = c(40,i),
                     tm_method = "tm",
                     tri_option = "two_strongest",
                     progress = F)
  tri <- na.omit(tri)
  tri <- tri_match(tri, ref)
  tri <- tri_error(tri)
  tri$max_angle <- i
  return(tri)
  
})

tri_max_angle <- do.call(rbind, tri_max_angle)
saveRDS(tri_max_angle, paste0(p$triangulations$here, "tri_maximal_angles.RDS"))


# try different time errors
#-------------------------------------------------------------
tri_error_time <- lapply(seq(0.1,2,0.1), function(t){
  
  tri <- triangulate(receiver_data, bearings, 
                     time_error_inter_station = t,
                     only_one = F,
                     angles_allowed = c(40,170),
                     tm_method = "tm",
                     tri_option = "two_strongest",
                     progress = F)
  tri <- na.omit(tri)
  tri <- tri_match(tri, ref)
  tri <- tri_error(tri)
  tri$error_time <- t
  return(tri)

})

tri_error_time <- do.call(rbind, tri_error_time)
saveRDS(tri_error_time, paste0(p$triangulations$here, "tri_error_time.RDS"))



# triangulation with different station combinations
#------------------------------------------------------------


station <-c("S1", "S2", "S3")

tri_stations <- lapply(seq(3), function(i){
  b <- bearings[bearings$Station != station[i],]
  
  tri <- triangulate(receiver_data, b, 
                     time_error_inter_station = 0.7,
                     only_one = F,
                     angles_allowed = c(0,180),
                     tm_method = "tm",
                     tri_option = "two_strongest",
                     spar = 3, 
                     progress = F)
  
  tri <- na.omit(tri)
  tri <- tri_match(tri, ref)
  tri <- tri_error(tri)
  tri$unused_station <- i
  return(tri)
  
})
tri_s <- do.call(rbind, tri_stations)

boxplot(tri_stations[[]]$refdist ~ tri_stations[[3]]$r_location, ylim = c(0,100))

s1_sp <- tri_sp(tri_stations[[2]])
mapview(s1_sp, zcol = "r_location") + mapview(refsp, color = "red") + mapview(antennas, color = "green")



