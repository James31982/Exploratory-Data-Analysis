library(ggplot2)


data <- read.table("household_power_consumption.txt", 
                   header=TRUE, sep=";", 
                   stringsAsFactors=FALSE, dec=".")

data.feb <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]

data.feb$Global_active_power <- as.numeric(data.feb$Global_active_power)
png("plot1.png", width=480, height=480)

ggplot(data.feb, aes(x=Global_active_power)) + geom_histogram(binwidth = 0.5, fill="red") +
        xlab("Global Active Power (kilowatts)") + ylab("Frequency")

dev.off()
