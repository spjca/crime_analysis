library(ggmap)

#making a test subset
a <- sdCrime.data[1:10,]

# this has the incorrect long/lat due to impartial address
# need to add city, state, and zip
x <- geocode(as.character(a$BLOCK_ADDRESS))

# create single character string of address
y <- paste(as.character(a$BLOCK_ADDRESS), "SAN DIEGO, CA ", as.character(a$ZipCode))

# success
z <- geocode(y)

# now to bring it all together
# first, will add column of addresses to sdCrime.data

sdCrime.data$fullAdr <- paste(as.character(sdCrime.data$BLOCK_ADDRESS),
                              ", SAN DIEGO, CA ",
                              as.character(sdCrime.data$ZipCode))

# ensure pacific beach subset has full address column
sdCrime.pb <- subset(sdCrime.data, sdCrime.data$ZipCode == 92109)

# then create data frame of long/lats
sdCrime.longlat <- geocode(sdCrime.pb$fullAdr)
# google limits the queries to 2500/day for non business accounts

# merge long/lat colums to pb data
sdCrime.pb$lon <- sdCrime.longlat$lon
sdCrime.pb$lat <- sdCrime.longlat$lat

# save data as csv
write.csv(sdCrime.pb, file = "pbCrime.csv", row.names = FALSE)
