## Exploratory Data Analysis
## Project 2
## Plot 4 - Total U.S. Coal-Related PM2.5 Emissions

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

## get all the Short.Names with Coal from the SCC data frame
patternChr <- "Coal"
coalVect <- grep(patternChr, sccTblDf$Short.Name, value = TRUE)
## get all the rows with Coal
coalSccTblDf <- filter(sccTblDf, Short.Name %in% coalVect)
## get only the SCC and Short.Name columns
coalSccTblDf <- select(coalSccTblDf, SCC, Short.Name)

## get all the rows with Coal SCCs in the NEI data frame
coalNeiTblDf <- filter(neiTblDf, SCC %in% coalSccTblDf$SCC)

## group by year then sum the Emissions
coalNeiByYrTblDf <- coalNeiTblDf %>%
        group_by(year) %>%
        summarize(sum(Emissions))
## assign variable names to the new data frame
names(coalNeiByYrTblDf) <- c("year", "Total.Emissions")

## create an exploratory plot of Coal-related Emissions by year
plot4 <- ggplot(coalNeiByYrTblDf, aes(year, Total.Emissions))
plot4 <- plot4 + geom_line() + 
        labs(title = "Total U.S. Coal-Related PM2.5 Emissions", 
             x = "Year", y = "Total Emissions (tons)")
print(plot4)

## create the plot as a .png file
dev.copy(png, file = "plot4.png")
dev.off()




