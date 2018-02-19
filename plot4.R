library(ggplot2)
library(scales)
library(gridExtra)
library(reshape2)
library(dplyr)

data <- read.table("household_power_consumption.txt", 
                   header=TRUE, sep=";", 
                   stringsAsFactors=FALSE, dec=".")


data.feb <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]
data.feb$Global_active_power <- as.numeric(data.feb$Global_active_power)
data.feb$Sub_metering_1 <- as.numeric(data.feb$Sub_metering_1)
data.feb$Sub_metering_2 <- as.numeric(data.feb$Sub_metering_2)
data.feb$Sub_metering_3 <- as.numeric(data.feb$Sub_metering_3)
data.feb$Voltage <- as.numeric(data.feb$Voltage)
data.feb$Global_reactive_power <- as.numeric(data.feb$Global_reactive_power)
data.feb$datetime <- strptime(paste(data.feb$Date, data.feb$Time, sep=" "), "%d/%m/%Y %H:%M:%S")

meltedJoins <- data.feb %>% select(datetime,Sub_metering_1,Sub_metering_2, Sub_metering_3 )
meltedJoins$datetime <- as.POSIXct(meltedJoins$datetime)
meltedJoins <- meltedJoins %>% filter(!is.na(datetime))
meltedJoins.r <- melt(meltedJoins, id = 'datetime')

png("plot4.png", width=480, height=480)

# plot 1
p1 <- ggplot(data.feb, aes(x=datetime, y = Global_active_power)) + geom_line() + 
        ylab("Global Active Power (kilowatts)") +
        theme(axis.title.x=element_blank()) + 
        scale_x_datetime(labels=date_format("%a"), breaks = date_breaks("days"), expand=c(0,0))

# plot 2
p2 <- ggplot(data.feb, aes(x=datetime, y = Voltage)) + geom_line() + 
        ylab("Voltage") + xlab("datetime") +
        scale_x_datetime(labels=date_format("%a"), breaks = date_breaks("days"), expand=c(0,0))

# plot 3

p3 <- ggplot(meltedJoins.r, aes(x = datetime, y = value, colour= variable)) + geom_line() + 
        ylab("Energy sub metering") +
        scale_colour_manual(values=c("black", "red", "blue")) + 
        theme(legend.position = c(0.8, 0.8)) + theme(legend.title=element_blank()) +
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              panel.background = element_blank()) + 
        scale_x_datetime(labels=date_format("%a"), breaks = date_breaks("days"), expand=c(0,0)) +
        theme(axis.line.y = element_line(color = "black")) + theme(axis.title.x=element_blank())



#plot 4
p4 <- ggplot(data.feb, aes(x=datetime, y = Global_reactive_power)) + geom_line() + 
        ylab("Global Reactive Power (kilowatts)") + xlab("datetime") +
        scale_x_datetime(labels=date_format("%a"), breaks = date_breaks("days"), expand=c(0,0))

grid.arrange(p1, p2, p3, p4, ncol=2)

dev.off()