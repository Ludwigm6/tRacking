#' distance from triangulation point to reference point

library(lubridate)
library(raster)

ref_distance <- function(tri, ref){
  # find out wich reference point matches with the triangulation by looking at the timestamp
  tri$refpoint <- NA
  tri$method <- NA
  for(i in seq(nrow(ref))){
    tri$refpoint[which(tri$timestamp > ref$start[i] & tri$timestamp < ref$end[i])] <- ref$name[i]
    tri$method[which(tri$timestamp > ref$start[i] & tri$timestamp < ref$end[i])] <- ref$method[i]
  }
  
  
  # calculate distance from each point to the reference point
  tri <- na.omit(tri)
  tri$refdist <- 0
  
  for(j in seq(nrow(tri))){
    tri$refdist[j] <- pointDistance(c(tri$pos.utm.X[j], tri$pos.utm.Y[j]), ref[which(tri$refpoint[j] == ref$name),7:8], lonlat = FALSE)
  }
  return(tri)
}


