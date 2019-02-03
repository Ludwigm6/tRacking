# calibration curves RTEU field test
library(ggplot2)


source("~/repositories/envimaR/R/getEnvi.R")
p <- getEnvi("/home/marvin/rteu/field_test/data/")
s <- getEnvi("/home/marvin/rteu/scripts/")

# source logger functions
source(paste0(s$here, "srvFileIO_reverse.R"))
source(paste0(s$here, "srvFilters_reverse.R"))

# read loger calibration data
logger_data <- read_logger_folder(p$logger_data$log_calibration$here)
logger_data$timestamp <- as.POSIXct(logger_data$timestamp, origin = "1970-01-01", tz = "UTC")

# filter frequency of interest
foi <- 150203
logger_data <- filter_data_freq(logger_data, freq = foi, freq_error = 2)


# Plot calibration curve
#---------------------------------------------------------

# relevel factor
logger_data$receiver <- factor(logger_data$receiver, levels = levels(logger_data$receiver)[seq(12,1,-1)])

#define color palette: 000 = red, 090 = yellow, 180 = green, 270 = blue
colpal <- c("red2", "gold1", "green4", "dodgerblue3")

# define timelimit
tlim <- c(as.POSIXct("2019-01-31 10:10:20", tz = "UTC"), as.POSIXct("2019-01-31 10:12:30", tz = "UTC"))


pdf(paste0(p$results$here, "calibration_S3.pdf"), width = 6, height = 6)
ggplot(logger_data[logger_data$Name == "S3",], aes(timestamp, max_signal, color = receiver))+
  geom_smooth(method = "gam", formula = y ~ s(x))+
  scale_color_manual(values = colpal, name = "Receiver")+
  scale_y_continuous(name = "Max signal [db]")+
  scale_x_datetime(name = "Time", expand = c(0,0), limits = tlim)+
  theme(panel.background = element_blank(), axis.line = element_line(color = "black"),
        panel.grid = element_line(color = "grey80"))

dev.off()





