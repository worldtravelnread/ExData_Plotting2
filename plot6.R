## Exploratory Data Analysis
## Project 2
## Plot 6 - Comparison of Baltimore City and Los Angeles Motor Vehicle-Related
## PM2.5 Emissions

## install packages and load libraries, if necessary
if(!require(dplyr, quietly = TRUE)) install.packages("dplyr")
library(dplyr)

if(!require(ggplot2, quietly = TRUE)) install.packages("ggplot2")
library(ggplot2)

## check to see if the new directory exists
## if not, create it then change the working directory
workingDirChr <- "~/Documents/DataScience_JH/ExploratoryDataAnalysis/project2"
if(!file.exists(workingDirChr)) {
        dir.create(workingDirChr)
}
setwd(workingDirChr)

## download data file
fileUrlChr <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrlChr, destfile = "FNEI_data.zip", method = "curl")
dateDownloadedDate <- date()
unzip("FNEI_data.zip", exdir = ".")

## this code double checks that the PM2.5 data file is in the working directory
if (!("summarySCC_PM25.rds" %in% list.files("."))) {
        stop ("Error: The PM2.5 data is not in your working directory.")    
}

## read in the data files
neiDf <- readRDS("summarySCC_PM25.rds")
sccDf <- readRDS("Source_Classification_Code.rds")

## load the data sets into table data frames
neiTblDf <- tbl_df(neiDf)
sccTblDf <- tbl_df(sccDf)

## get all the Short.Names with Motor Vehicles from the SCC data frame
patternChr <- "Motor Vehicle"
mvVect <- grep(patternChr, sccTblDf$Short.Name, value = TRUE)
## get all the rows with Motor Vehicle
mvSccTblDf <- filter(sccTblDf, Short.Name %in% mvVect)
## get only the SCC and Short.Name columns
mvSccTblDf <- select(mvSccTblDf, SCC, Short.Name)

## get all the rows with Motor Vehicle SCCs in the NEI data frame
mvNeiTblDf <- filter(neiTblDf, SCC %in% mvSccTblDf$SCC)

## get only the Baltimore City  & LA data from the Motor Vehicle NEI data frame
compareMvNeiTblDf <- subset(mvNeiTblDf, fips == "24510" | fips == "06037")
## arrange the data frame by fips in ascending order
compareMvNeiTblDf <- arrange(compareMvNeiTblDf, fips)

## create a city data frame for the fips
city <- data.frame(fips = c("06037", "24510"), 
                   city = c("Los Angeles", "Baltimore City"))
## create a table data frame of city
cityTblDf <- tbl_df(city)

## merge the LA and Baltimore NEI data with the city data
compareMvNeiTblDf <- merge(compareMvNeiTblDf, cityTblDf, 
                           by.x = "fips", by.y = "fips")


## create an exploratory plot of Baltimore & LA Motor Vehicle-related Emissions 
## by year
plot6 <- ggplot(compareMvNeiTblDf, aes(year, Emissions))
plot6 <- plot6 + geom_line() + facet_grid(. ~ city) +
        labs(title = "Comparison of Motor Vehicle-Related PM2.5 Emissions", 
             x = "Year", y = "Total PM2.5 Emissions (tons)")
print(plot6)

## create the plot as a .png file
dev.copy(png, file = "plot6.png")
dev.off()




