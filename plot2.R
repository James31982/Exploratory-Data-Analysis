library(ggplot2)
library(scales)

data <- read.table("household_power_consumption.txt", 
                   header=TRUE, sep=";", 
                   stringsAsFactors=FALSE, dec=".")


data.feb <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]
data.feb$Global_active_power <- as.numeric(data.feb$Global_active_power)

data.feb$datetime <- strptime(paste(data.feb$Date, data.feb$Time, sep=" "), "%d/%m/%Y %H:%M:%S")

# now I have a vector with time dates (POSIXlt format)
png("plot2.png", width=480, height=480)
ggplot(data.feb, aes(x=datetime, y = Global_active_power)) + geom_line() + 
        ylab("Global Active Power (kilowatts)") +
        theme(axis.title.x=element_blank()) + 
        scale_x_datetime(labels=date_format("%a"), breaks = date_breaks("days"), expand=c(0,0))

dev.off()
