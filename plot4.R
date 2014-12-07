# Start of getting an loading data
# On my machine (a 4-year old netbook) this process takes about 

library(data.table)

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileLocal <- "./data.zip"
unzippedFile <- "household_power_consumption.txt"

# Download and unzip the file
if(!file.exists(unzippedFile)){
  download.file(fileURL, fileLocal, method="wget")
  unzip(fileLocal)
}

# Use a data table, since faster than a data frame
# Large file, reading it in may still take a few seconds
dataTable <- fread(unzippedFile, head=T, sep=";", na.string=c("?"))
# Convert dates and then subset:
dataTable[,Date := as.Date(Date, format="%d/%m/%Y")]
dataTable <- dataTable[Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02")]

# Bizarrely, fread still chooses to interrpret '?' as a character,
# not as an NA. This appears to be a documented and unfixed bug.
# Therfore the following lines are necessary:
dataTable[,Global_active_power := as.numeric(Global_active_power)]
dataTable[,Global_reactive_power := as.numeric(Global_reactive_power)]
dataTable[,Voltage := as.numeric(Voltage)]
dataTable[,Global_intensity := as.numeric(Global_intensity)]
dataTable[,Sub_metering_1 := as.numeric(Sub_metering_1)]
dataTable[,Sub_metering_2 := as.numeric(Sub_metering_2)]
dataTable[,Sub_metering_3 := as.numeric(Sub_metering_3)]
# Getting and loading data complete
# (note that Time is still as characters)

# Make plot 2
png(filename= "plot4.png", width = 480, height = 480)
# Set up for 2 column, 2 row format, filling row-wise:
par(mfrow=c(2,2))

# Top left plot (same as plot 2)
with(dataTable, plot(strptime(paste(Date, Time, sep=" "), format="%Y-%m-%d %H:%M:%S"), Global_active_power, type="n", main="", xlab = "", ylab = "Global Active Power"))
with(dataTable, lines(strptime(paste(Date, Time, sep=" "), format="%Y-%m-%d %H:%M:%S"), Global_active_power))

# Top right plot
with(dataTable, plot(strptime(paste(Date, Time, sep=" "), format="%Y-%m-%d %H:%M:%S"), Voltage, type="n", main="", xlab = "datetime", ylab = "Voltage"))
with(dataTable, lines(strptime(paste(Date, Time, sep=" "), format="%Y-%m-%d %H:%M:%S"), Voltage, col="black"))

# Bottom left graph (same as plot 3)
# Set up the plot (using Sub_metering_1 since that acheives the highest values)
with(dataTable, plot(strptime(paste(Date, Time, sep=" "), format="%Y-%m-%d %H:%M:%S"), Sub_metering_1, type="n", main="", xlab = "", ylab = "Energy sub metering"))
# Actually plot the lines
with(dataTable, lines(strptime(paste(Date, Time, sep=" "), format="%Y-%m-%d %H:%M:%S"), Sub_metering_1, col="black"))
with(dataTable, lines(strptime(paste(Date, Time, sep=" "), format="%Y-%m-%d %H:%M:%S"), Sub_metering_2, col="red"))
with(dataTable, lines(strptime(paste(Date, Time, sep=" "), format="%Y-%m-%d %H:%M:%S"), Sub_metering_3, col="blue"))
# Include the legend
with(dataTable, legend("topright", col=c("black","red","blue"), lty=c(1,1,1), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n"))

# Bottom right plot
with(dataTable, plot(strptime(paste(Date, Time, sep=" "), format="%Y-%m-%d %H:%M:%S"), Global_reactive_power, type="n", main="", xlab = "datetime", ylab = "Global_reactive_power"))
with(dataTable, lines(strptime(paste(Date, Time, sep=" "), format="%Y-%m-%d %H:%M:%S"), Global_reactive_power), col="black")

dev.off()

#Done!
