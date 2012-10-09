# Stepwise spatiotemporal estimation
library(geoR)


# variogram for the beta-field

# creating spatial points data set
geo_data <- as.data.frame(cbind(station$long, station$lat, beta))
rownames(geo_data) <- rownames(beta)

# lcrs <- CRS("+proj=longlat +ellps=WGS84")
# mdb_beta_sp <- SpatialPoints(longlat, proj4string = lcrs)

# creating spatialpointsdataframe

# mdb_beta_data1 <- SpatialPointsDataFrame(longlat, beta, proj4string = lcrs)

# change to geoR data

mdb_geo_data1 <- as.geodata(geo_data, data.col=3)
mdb_geo_data2 <- as.geodata(geo_data, data.col=4)
mdb_geo_data3 <- as.geodata(geo_data, data.col=5)

# variogram estimation for beta0
variog_beta0 <- variog(mdb_geo_data1)
plot(variog_beta0)
# add the thepretical lines: spherical, nugget is 0, sill is 0.3, and range is 6
lines.variomodel(cov.model = "sph", cov.pars = c(0.3, 6), nug = 0, max.dist = 15)

variog_beta1 <- variog(mdb_geo_data2)
plot(variog_beta1)
# add the thepretical lines: exponential, nugget is 0, sill is 0.014, and range is 5
lines.variomodel(cov.model = "exp", cov.pars = c(0.014, 5), nug = 0, max.dist = 15)

variog_beta2 <- variog(mdb_geo_data3)
plot(variog_beta2)
lines.variomodel(cov.model = "gau", cov.pars = c(0.5, 9), nug = 0, max.dist = 15)