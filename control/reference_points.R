# formating of gps reference points
#-----------------------------
library(rgdal)
library(raster)

source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/marvin/rteu/field_test/data/")
s <- getEnvi("/home/marvin/rteu/field_test/scripts/")

# load gps source
ref <- read.table(paste0(p$gps_data$here, "gps_raw_export.txt"), sep = ",", header = TRUE)
ref$X <- NULL
ref$Basis.Ant.H. <- NULL
ref$Basis <- NULL


# define timestamps
ref$timestamp_start <- as.POSIXct(paste(ref$Datum.Start..UTC., ref$Zeit.Start..UTC.),
                                  format = "%d-%m-%Y %H:%M:%S", tz = "UTC")

ref$timestamp_end <- as.POSIXct(paste(ref$Datum.Ende..UTC., ref$Zeit.Ende..UTC.),
                                format = "%d-%m-%Y %H:%M:%S", tz = "UTC")


# reproject WGS
refsp <- ref
coordinates(refsp) <- ~ Punkt.Ost.O + Punkt.Nord.N
projection(refsp) <- CRS("+init=epsg:25832")

refsp_WGS <- spTransform(refsp, CRS("+init=epsg:4326"))
ref$Punkt.Brg. <- coordinates(refsp_WGS)[,2]
ref$Punkt.Läg. <- coordinates(refsp_WGS)[,1]


# filter relevant information
ref <- data.frame(name = as.character(ref$Name),
                  utm_o = ref$Punkt.Ost.O,
                  utm_n = ref$Punkt.Nord.N,
                  utm_z = ref$Punkt.Z.Z,
                  wgs_o = ref$Punkt.Läg.,
                  wgs_n = ref$Punkt.Brg.,
                  code = ref$Code,
                  time_start = ref$timestamp_start,
                  time_end = ref$timestamp_end,
                  stringsAsFactors = FALSE)

ref <- ref[!ref$code == "ANTENNA",]
ref <- ref[nchar(ref$name)!=2,]

# location names
ref$location <- substr(ref$name, 1,2)


# method (RUHE, MOVE or WALK)
ref$method <- "WALK"
ref$method[substr(ref$location,1,1) == "M"] <- gsub('[[:digit:]]+', '',
                                                    substr(ref$name,2,nchar(ref$name))[substr(ref$location,1,1) == "M"])


# first five entries were a deprecated test run, remove them
ref <- ref[-1:-5,]

# save
write.csv(ref, paste0(p$gps_data$here, "reference_points.csv"), row.names = FALSE)



#----------------------------------------------------------

# create LUT for start and end per measure point
library(lubridate)

lut_times <- aggregate.data.frame(ref$time_start,
                                  by = list(location = ref$location, method = ref$method),
                                  FUN = min)

colnames(lut_times) <- c("location", "method", "start")

lut_times$end <- aggregate.data.frame(ref$time_start,
                                    by = list(location = ref$location, method = ref$method),
                                    FUN = max)$x

lut_times$start <- with_tz(lut_times$start, "UTC")
lut_times$end <- with_tz(lut_times$end, "UTC")


lut_times$id <- paste0(lut_times$location, "_", lut_times$method)

# location of the points
lut_times$pos.X <-  aggregate.data.frame(ref$wgs_o,
                                         by = list(location = ref$location, method = ref$method),
                                         FUN = mean)$x
lut_times$pos.Y <-  aggregate.data.frame(ref$wgs_n,
                                         by = list(location = ref$location, method = ref$method),
                                         FUN = mean)$x
lut_times$pos.utm.X <- aggregate.data.frame(ref$utm_o,
                                            by = list(location = ref$location, method = ref$method),
                                            FUN = mean)$x
lut_times$pos.utm.Y <- aggregate.data.frame(ref$utm_n,
                                            by = list(location = ref$location, method = ref$method),
                                            FUN = mean)$x

# bearing angles to the antennas
source(paste0(s$tRacking$src$here, "point_bearings.R"))

antennas <- read.csv(paste0(p$gps_data$here, "antennas.csv"))
antennas <- antennas[c(1,5,9),]

lut_times$bearing_s1 <- be(lut_times$pos.Y - antennas$Latitude[1], lut_times$pos.X - antennas$Longitude[1])
lut_times$bearing_s2 <- be(lut_times$pos.Y - antennas$Latitude[2], lut_times$pos.X - antennas$Longitude[2])
lut_times$bearing_s3 <- be(lut_times$pos.Y - antennas$Latitude[3], lut_times$pos.X - antennas$Longitude[3])

# save
write.csv(lut_times, paste0(p$gps_data$here, "lut_measures.csv"), row.names = FALSE)
saveRDS(lut_times, paste0(p$gps_data$here, "lut_measures.RDS"))





