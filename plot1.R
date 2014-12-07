# Start of getting an loading data
# On my machine (a 4-year old netbook) this process takes about 

library(data.table)

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileLocal <- "./data.zip"
unzippedFile <- "household_power_consumption.txt"

# Download and unzip the file
download.file(fileURL, fileLocal, method="wget")
unzip(fileLocal)

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

# Make plot 1
png(filename= "plot1.png", width = 480, height = 480)
with(dataTable, hist(Global_active_power, col="red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power"))
dev.off()

#Done!
