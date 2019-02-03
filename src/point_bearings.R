#' Bearing angle, clockwise from North in 360 degrees
#' 
#' 
#' 
#' 
#' 


be <- function(y,x){
  b <- (atan2(y, x)*(180/pi))-90
  ifelse(b <= 0, 360-(360+b),  360-b)
}
