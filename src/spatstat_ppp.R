library(spatstat)

marks <- as.data.frame(cbind(rain=apply(hqmr.data[, -79], 2, mean, na.rm = TRUE), missing=nmissing_station$nmissings))
PX <- ppp(nmissing_station$Lon, nmissing_station$Lat, 
          range(nmissing_station$Lon)+c(-2, 2), range(nmissing_station$Lat) + c(-2, 2), 
          marks= marks)
# plot the mean rainfall and missingness of the 78 stations
par(mfrow = c(1, 2))
plot(PX,main = "Mean of Rainfall in 78 Stations")
plot(PX, which.marks = "missing", main = "Missing Profile of 78 Stations") 
par(mfrow = c(1, 1))

# a two-dimensional pixel image for the hqmr data
noisy <- im(head(as.matrix(hqmr.cube), 78))
plot(noisy) # too many rows is a worry
