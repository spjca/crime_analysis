# san diego crime data analysis

# load packages
library(timeSeries)#allows for easier time series analysis
library(lubridate)#allows for easier manipulation of time data
library(zoo)#allows analysis of time series data
library(maps)
library(maptools)
library(ggmap) # to convert street addresses to longitude/latitude

# set working directory  
setwd("C:/Users/SPJ/Documents/R/SDOpen/Crime")

# load data with header from csv file and assign as variable
sdCrime.data <- read.csv('arjis.csv', header = TRUE)#, sep = ",")

# cleaning the data
# start by reviewing each column

summary(sdCrime.data$agency)
# no glaring errors, will leave everything as is

summary(sdCrime.data$Charge_Description_Orig)
unique(sdCrime.data$Charge_Description_Orig)
# this can be useful by breaking everything down into more 
# broad catagories such as drugs, theft, violence, weapon, etc

summary(sdCrime.data$activityDate)
# this can be broken down into date and time columns for a more
# granular view and also can create month indicators based on this data

summary(sdCrime.data$BLOCK_ADDRESS)
unique(sdCrime.data$BLOCK_ADDRESS)
# need to look into getting the long/lat coordinants for each 
# of these locations for projection onto a map

summary(sdCrime.data$ZipCode)
# everything looks good here

summary(sdCrime.data$community)
unique(sdCrime.data$community)
# this will need some cleaningto be useful
# the street level data may be more useful
# may need to use street level data to infer community for blank spots


sdCrime.pb <- subset(sdCrime.data, sdCrime.data$ZipCode == 92109)

####################################################
# use the long/lat script to create long/lat colmns#
####################################################

# order by datetime
# change activityDate from factor to posix to allow for sorting
sdCrime.pb$activityDate <- as.POSIXct(sdCrime.pb$activityDate, 
                                     format = "%m/%d/%Y %H:%M:%S")
# sort activityDate column decending
sdCrime.pb <- sdCrime.pb[order(sdCrime.pb$activityDate, decreasing = FALSE),]


# create more broad catagories for the specific charges to fit into
# this is in order to simplify the data and make it easier to understand
# also this can allow for further analysis into subtypes of crime
# this can be done in several ways: levels of crime, catagories of crime,
# or a breakdown of the sub types of catagories

# http://www.legalmatch.com/law-library/article/what-are-the-different-types-of-crimes.html
# for my purposes, it may be interesting to do all three

# created csv file of unique crimes in charge_description then made attempt to more
# broadly classify these crimes by type for easier analysis
crimes <- data.frame(unique(sdCrime.pb$Charge_Description_Orig))
write.csv(crimes, file = 'crimes.csv')
crimes.type <- read.csv(file='crime.granular.csv')

# create index
index <- crimes.type$unique.sdCrime.pb.Charge_Description_Orig.
values <- crimes.type$offense
# create column of types of crime based on index
sdCrime.pb$type <- values[match(sdCrime.pb$Charge_Description_Orig, index)]

# create day of week column
sdCrime.pb$weekday <- weekdays(as.Date(sdCrime.pb$activityDate))

# create month of year column
sdCrime.pb$month <- month(as.Date(sdCrime.pb$activityDate))

# create hour column
#x <- strptime(sdCrime.pb$activityDate, format = "%Y/%m/%d %H:%M:%S")
sdCrime.pb$hour <- sdCrime.pb$activityDate$hour

# create hour column


#######
# viz #
#######

# map out crime data

# create map
beachMap <- qmap('pacificbeach', zoom = 13,color = 'bw')
# add data points based on longitude and latitude
beachMap +geom_point(data=sdCrime.pb, aes(x=lon,y=lat),
                     color="green")

beachMap + stat_density2d(data=sdCrime.pb, aes(x=lon,y=lat),
                        color=..density..)



# viz based type and size by type
beachMap +geom_point(aes(x = lon, y = lat, 
                           size = type,
                         colour = type), data = sdCrime.pb )

# viz based on type==drugs and size by month
beachMap +geom_point(aes(x = lon, y = lat, 
                         size = weekday,
                         colour = month), data = sdCrime.pb)


pbMap <- qmap('pacificbeach', zoom = 14)
beachMap <- ggmap(pbMap, extent='device', llegend = 'topleft')

beachMap + stat_density2d(aes(x = lon, y = lat, 
                                fill = ..level.. , alpha = ..level..),size = 2, bins = 4, 
                            data = sdCrime.pb, geom = 'polygon') 

