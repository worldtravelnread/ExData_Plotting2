## Exploratory Data Analysis
## Project 2
## Plot 5 - Total Baltimore City Motor Vehicle-Related PM2.5 Emissions

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

## get only the Baltimore City data from the Motor Vehicle NEI data frame
baltMvNeiTblDf <- subset(mvNeiTblDf, fips == "24510")

## create an exploratory plot of Baltimore Motor Vehicle-related Emissions 
## by year
plot5 <- ggplot(baltMvNeiTblDf, aes(year, Emissions))
plot5 <- plot5 + geom_line() + 
        labs(title = "Total Baltimore City Motor Vehicle-Related 
             PM2.5 Emissions", x = "Year", y = "Total PM2.5 Emissions (tons)")
print(plot5)

## create the plot as a .png file
dev.copy(png, file = "plot5.png")
dev.off()




