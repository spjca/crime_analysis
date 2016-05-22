# this function shows how to create a new column based on an index 

sd <- read.csv(file = "pbCrime.csv", header=TRUE)
crimes <- read.csv(file = "crime.granular.csv", header=TRUE)
dat <- data.frame(sd$Charge_Description_Orig)

index <- crimes$unique.sdCrime.pb.Charge_Description_Orig.
values <- crimes$offense
dat$type <- values[match(dat$sd.Charge_Description_Orig, index)]
