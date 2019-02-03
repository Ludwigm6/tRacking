# formating of gps reference points
#-----------------------------
source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/marvin/rteu/field_test/data/")
s <- getEnvi("/home/marvin/rteu/scripts/")

# load gps source
ref <- read.table(paste0(p$reference_points$here, "field_test.txt"), sep = ",", header = TRUE)
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
                  wgs_o = ref$Punkt.Brg.,
                  wgs_n = ref$Punkt.Läg.,
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


# save
write.csv(ref, paste0(p$reference_points$here, "reference_points.csv"), row.names = FALSE)


# filter methods
#--------------------------------
ruhe <- ref[ref$method == "RUHE",]
ruhe <- ruhe[-1:-5,]

write.csv(ruhe, paste0(p$reference_points$here, "ruhe_points.csv"), row.names = FALSE)



