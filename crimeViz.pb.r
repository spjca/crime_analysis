# pacific beach crime viz

# source inspiration
# https://journal.r-project.org/archive/2013-1/kahle-wickham.pdf

# data cleaned using sd.crime.review.r

### tile map

# create map layer
beachMap <- qmap('pacificbeach', zoom = 13,color = 'bw')

# create data viz layer of long/lat positions differentiaed by type
beachMap +
  stat_bin2d(
    aes(x=lon, y=lat, colour = type, fill = type),
    size = .5, bins =  30, alpha = 1/2,
    data = sdCrime.pb
  )

### heat map
# will use previously generated map layer
beachMap +
  stat_density2d(
    aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
    size = 2, bins = 9,
    data = sdCrime.pb, 
    geom = "polygon"
  )

# subset violent crimes
pbCrime.violent <- subset(sdCrime.pb, sdCrime.pb$type == 'violent')

beachMap +
  stat_density2d(
    aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
    size = 2, bins = 9,
    data = pbCrime.violent, 
    geom = "polygon"
  )

# subset drug crimes
pbCrime.drugs <- subset(sdCrime.pb, sdCrime.pb$type == 'drugs')

beachMap +
  stat_density2d(
    aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
    size = 2, bins = 9,
    data = pbCrime.drugs, 
    geom = "polygon"
  )

# subset sex crimes
pbCrime.sex <- subset(sdCrime.pb, sdCrime.pb$type == 'sexual')

beachMap +
  stat_density2d(
    aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
    size = 2, bins = 9,
    data = pbCrime.sex, 
    geom = "polygon"
  )

# subset theft crimes
pbCrime.theft <- subset(sdCrime.pb, sdCrime.pb$type == 'theft')

beachMap +
  stat_density2d(
    aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
    size = 2, bins = 9,
    data = pbCrime.theft, 
    geom = "polygon"
  )

### source inspiration
# https://rpubs.com/jimu_xw/crime_visualization

# visualize frequency of crime by dot plot 

# create data frame of counts of lon/lat position frequency
lonLatCounts <- as.data.frame(table(round(sdCrime.pb$lon,3), 
                                    round(sdCrime.pb$lat,3)))


# convert lon/lat variables to numbers
lonLatCounts$lon <- as.numeric(as.character(lonLatCounts$Var1))
lonLatCounts$lat <- as.numeric(as.character(lonLatCounts$Var2))

# using previous base map
beachMap +
  geom_point(
    data = lonLatCounts, 
    aes(x = lon, y = lat, color = Freq, size = Freq)
  )


# create subset with non zero frequency
lonLatCountsPlus <- subset(lonLatCounts, Freq >0)

# create heatmap
beachMap + geom_tile(
  data = lonLatCounts,
  aes(x=lon, y = lat, alpha = Freq),
  fill = "red")


### data viz

