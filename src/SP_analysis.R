
# Data set-up for trend estimation
load("keyobject.Rdata")
source("functions.R")
library(SpatioTemporal)

# 
HeatStruct(hqmr.cube)
rownames(hqmr.cube) <- date.month
hqmr.cube$date <- date.month
hqmr.cube <- hqmr.cube[-(1:360), ]
# impute missing values by cutoff method
mdbdata <- Cut(hqmr.cube) # mdbdata is a new data matrix with missing values being imputed

# run leave one out cross-validataion to find smooth trends

SVD.cv <- SVDsmoothCV(mdbdata, 1:5)

plot(SVD.cv)


################### creating STdata object for MDB data #######################

# creating "obs"
library(reshape2) # we need the "melt" function

obs <- melt(t(mdbdata))[, c(3, 2, 1)] # we want the data look exactly like the data in the pkg tutprial
names(obs) <- c("obs", "date", "ID")
obs$date <- as.Date(as.character(obs$date))

# creating "covars" 
load("station_info.Rdata")

# calculating the xy coordinates
attach(stations)
xcoor <- 111.13*Lon*cos(34.021*pi/180)
ycoor <- 111.13*Lat


# creating covars, with ID , x$y coordinates and alt as the only LUR covariate
covars <- data.frame(ID = colnames(mdbdata), x = xcoor, y = ycoor, long = Lon, 
                     lat = Lat, alt = stations$Alt)

STmdb <- createSTdata(obs, covars)




# compute new temporal smooths

F <- calcSmoothTrends(STmdb, n.basis = 2)

# add the new trends to the data structure
STmdb$trend <- F$trend

STmdb <- updateSTdataTrend(STmdb, n.basis = 2)

# plot the obs at some locations with the fitted smooth trends

par(mfrow=c(4,1),mar=c(2.5,2.5,2,.5))
plot(STmdb, "obs", ID=5)
plot(STmdb, "obs", ID=18)

##also plot the residuals

plot(STmdb, "res", ID=5)
plot(STmdb, "res", ID=18)

# # acf plot of the residuals, its not working now...
# 
# par(mfcol=c(2,2),mar=c(2.5,2.5,3,.5))
# plot(STmdb, "acf", ID=1)
# plot(STmdb, "acf", ID=5)
# plot(STmdb, "acf", ID=13)
# plot(STmdb, "acf", ID=18)

## create data matrix
D <- createDataMatrix(STmdb)
beta <- matrix(NA,dim(D)[2], dim(STmdb$trend)[2])
beta.std <- beta
##extact the temporal trends

F <- STmdb$trend
##drop the date column
F$date <- NULL
for(i in 1:dim(D)[2]){
  tmp <- lm(D[,i] ~ as.matrix(F))
  beta[i,] <- coef(tmp)
  beta.std[i,] <- sqrt(diag(vcov(tmp)))
}

##Add names to the estimated betas
colnames(beta) <- c("const",colnames(F))
rownames(beta) <- colnames(D)
dimnames(beta.std) <- dimnames(beta)
head(beta)


## define land-use covariates
LUR <- list("long", "lat", "alt")
# exponential covariance for the beta-fileds and no nugget effect
cov.beta <- list(covf = "exp", nugget = FALSE)
# exponential covariance for the nu-fileds and including nugget effect
# random.effect = FALSE, specifies the we want to use a constant nugget

cov.nu <- list(covf = "exp", nugget = TRUE, random.effect = FALSE)

# define which location to use
locations <- list(coords = c("x","y"), long.lat = c("long","lat"))

## create object
mdb.model <- createSTmodel(STmdb, LUR = LUR, cov.beta = cov.beta, cov.nu = cov.nu, locations = locations)

# OPTIONS

# cov.beta2 <- list(covf = c("exp", "exp2", "iid"), nugget = c(FALSE, FALSE, TRUE))
# mds.model2 <- updateCovf(mdb.model, cov.beta = cov.beta2)

## Parameter Estimation

# take a look at the important dimensions of the model
model.dim <- loglikeSTdim(mdb.model)
model.dim 

# setting up the initial parameter values for optimization
x.init <- cbind(rep(2, model.dim$nparam.cov), c(rep(c(1, -3), model.dim$m+1), -3))

loglikeSTnames(mdb.model, all = FALSE)
# add names to the initial values

rownames(x.init) <- loglikeSTnames(mdb.model, all = FALSE)

## Estimate model parameters

est.mdb.model <- estimate(mdb.model, x.init, type = "p", hessian = TRUE)


