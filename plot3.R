## Exploratory Data Analysis
## Project 2
## Plot 3 - Baltimore City PM2.5 Emissions by Source Type

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

baltTblDf <- subset(neiTblDf, fips == "24510")

## get the unique years from the data frame
uniqueYrInt <- unique(baltTblDf$year)

## group by type and year
byTypeByYrTblDf <- group_by(baltTblDf, type, year)
## summarize emissions
baltTypeByYrTblDf <- summarize(byTypeByYrTblDf, sum(Emissions))
## name the columns of the new data frame
names(baltTypeByYrTblDf) <- c("type", "year", "total.Emissions")

## create an exploratory plot of the sum of the Emissions by type by year
plot3 <- qplot(year, total.Emissions, data = baltTypeByYrTblDf, 
      geom = "line", facets = . ~ type) + 
        labs(title = "Total Baltimore City PM2.5 Emissions by Source Type", 
             x = "Year", y = "Total Emissions (tons)")
print(plot3)

## create .png file of plot
png(filename = "plot3.png", width = 480, height = 480)
plot3 <- qplot(year, total.Emissions, data = baltTypeByYrTblDf, 
      geom = "line", facets = . ~ type) + 
        labs(title = "Total Baltimore City PM2.5 Emissions by Source Type", 
             x = "Year", y = "Total Emissions (tons)")
print(plot3)
dev.off()

