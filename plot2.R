## Exploratory Data Analysis
## Project 2
## Plot 2 - Total Baltimore City PM2.5 Emissions

## install packages and load libraries, if necessary
if(!require(dplyr, quietly = TRUE)) install.packages("dplyr")
library(dplyr)

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

baltTblDf <- subset(neiTblDf, fips == "24510")

## get the number of observations for each year
baltObservByYearInt <- sapply(split(baltTblDf, baltTblDf$year), nrow)

## total the emissions by year
baltSumByYearArry <- with(baltTblDf, tapply(Emissions, year, sum))

## create an exploratory plot of the sum of the Emissions by year
plot(names(baltObservByYearInt), baltSumByYearArry, type = "l", 
     xlab = "Year", ylab = "Total PM2.5 Emissions (tons)", 
     main = "Baltimore City PM2.5 Emissions")

## create the plot as a .png file
png(filename = "plot2.png", width = 480, height = 480)
plot(names(baltObservByYearInt), baltSumByYearArry, type = "l", 
     xlab = "Year", ylab = "Total PM2.5 Emissions (tons)", 
     main = "Baltimore City PM2.5 Emissions")
dev.off()




