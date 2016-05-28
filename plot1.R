## Exploratory Data Analysis
## Project 2
## Plot 1 - Total U.S. PM2.5 Emissions

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

## get the number of observations for each year
observByYearInt <- sapply(split(neiTblDf, neiTblDf$year), nrow)

## total the emissions by year
sumByYearArry <- with(neiTblDf, tapply(Emissions, year, sum))

## create an exploratory plot of the sum of the Emissions by year
plot(names(observByYearInt), sumByYearArry, type = "l", 
     xlab = "Year", ylab = "Total PM2.5 Emissions (tons)", 
     main = "U.S. PM2.5 Emissions from All Sources")

## create the plot as a .png file
## plot to .png
png(filename = "plot1.png", width = 480, height = 480)
plot(names(observByYearInt), sumByYearArry, type = "l", 
     xlab = "Year", ylab = "Total PM2.5 Emissions (tons)", 
     main = "U.S. PM2.5 Emissions from All Sources")
dev.off()




