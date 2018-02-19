library(reshape2)
library(ggplot2)
library(dplyr)
library(scales)
library(gridExtra)

data <- read.table("household_power_consumption.txt", 
                   header=TRUE, sep=";", 
                   stringsAsFactors=FALSE, dec=".")

data.feb <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]
data.feb$Global_active_power <- as.numeric(data.feb$Global_active_power)
data.feb$Sub_metering_1 <- as.numeric(data.feb$Sub_metering_1)
data.feb$Sub_metering_2 <- as.numeric(data.feb$Sub_metering_2)
data.feb$Sub_metering_3 <- as.numeric(data.feb$Sub_metering_3)

data.feb$datetime <- strptime(paste(data.feb$Date, data.feb$Time, sep=" "), "%d/%m/%Y %H:%M:%S")

meltedJoins <- data.feb %>% select(datetime,Sub_metering_1,Sub_metering_2, Sub_metering_3 )
meltedJoins$datetime <- as.POSIXct(meltedJoins$datetime)
meltedJoins <- meltedJoins %>% filter(!is.na(datetime))
meltedJoins.r <- melt(meltedJoins, id = 'datetime')

png("plot3.png", width=480, height=480)

ggplot(meltedJoins.r, aes(x = datetime, y = value, colour= variable)) + geom_line() + ylab("Energy sub metering") +
        scale_colour_manual(values=c("black", "red", "blue")) + theme(legend.position = c(0.8, 0.8)) + theme(legend.title=element_blank()) +
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              panel.background = element_blank()) + 
        scale_x_datetime(labels=date_format("%a"), breaks = date_breaks("days"), expand=c(0,0)) +
        theme(axis.line.y = element_line(color = "black"))


dev.off()
