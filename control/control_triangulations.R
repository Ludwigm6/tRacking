# triangulation function

source("~/rteu/field_test/scripts/tRacking/src/init_triangulation.R")

# filter bearings
bearings <- bearings[bearings$antennas > 3,]
bearings <- bearings[bearings$method == "MOVE",]

tri <- triangulate(receiver_data, bearings, 
                   time_error_inter_station = 2,
                   only_one = F,
                   angles_allowed = c(30,150),
                   tm_method = "tm",
                   tri_option = "two_strongest",
                   spar = 3, 
                   progress = F)

tri <- na.omit(tri)


tri <- tri_match(tri, ref)

trisp <- tri_sp(tri)

tri <- tri_error(tri)

boxplot(tri$refdist ~ tri$r_location)

refsp <- ref
coordinates(refsp) <- ~ pos.X + pos.Y
projection(refsp) <- CRS("+proj=longlat +datum=WGS84")


mapview(trisp, zcol = "r_location") + mapview(refsp, color = "red")
