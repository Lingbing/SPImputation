
# Data set-up for trend estimation
load("keyobject.Rdata")
source("functions.R")
library(SpatioTemporal)

# 
HeatStruct(hqmr.cube)
rownames(hqmr.cube) <- date.month
hqmr.cube$date <- date.month
hqmr.cube <- hqmr.cube[1:240, ]
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

# calculating the xy coordinates
load("station.Rdata")
xcoor <- 111.13*station$long*cos(34.021*pi/180)
ycoor <- 111.13*station$lat


# creating covars, with ID , x$y coordinates and alt as the only LUR covariate
covars <- data.frame(ID = colnames(mdbdata), x = xcoor, y = ycoor, long = station$long, 
                     lat = station$lat, alt = station$elav)

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
LUR <- list(c("long","lat","alt"), c("long","lat","alt"), c("long","lat","alt"))
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

est.mdb.model <- estimate(mdb.model, x.init, type = "p", hessian = FALSE)

## evaluating (studying) the results

print(est.mdb.model)
names(est.mdb.model)
names(est.mdb.model$res.best)
names(est.mdb.model$res,all[[1]])


# extract the estimated parameters and approximate uncertainties
x <- est.mdb.model$res.best$par.all

## plot the estimated parameters with uncertainties
par(mfrow = c(1, 1), mar = c(13.5, 2.5, .5, .5))
plot(x$par, ylim = range(x(x$par - 1.96*x$sd, x$par + 1.96*x$sd)), xlab = "", xaxt="n")
points(x$par - 1.96*x$sd, pch = 3)
points(x$par + 1.96*x$sd, pch = 3)
axis(1, 1:length(x$par), rownames(x), las = 2)

## Predictions

# compute conditional expectations 
pred.mdb.model <- predict(mdb.model, est.mdb.model, pred.var = TRUE)

##Start by comparing beta fields
library(ggplot2)

X <- vector("list", 3)
for (i in 1:3){
X[[i]] <- as.data.frame(cbind(beta[, i], pred.mdb.model$beta$EX[, i], 1.96*beta.std[, i],
                          1.96*sqrt(pred.mdb.model$beta$VX[, i])))
}

plot_beta <- vector("list", 3)

for (i in 1:3) {
  
  ii = i
  plot_beta[[i]] <- ggplot(X[[i]], aes(V1, V2)) +
    geom_point(col = "red") +
    geom_errorbarh(aes(xmax = V1 + V3, xmin = V1 - V3), lty=3, col = "darkblue") +
    geom_errorbar(aes(ymax = V2 + V4, ymin = V2 - V4), lty=3, col = "darkblue") +
    geom_abline(intercept = 0, slope = 1, col = "grey") + 
    xlab("Empirical Estimate") + ylab("SpatioTemporal model")         
}

# show the comparing plot and some plot polishing(mainly on changing fonts family and size)

plot_beta1 <- plot_beta[[1]] + ggtitle(expression(paste("Comparison for beta fields: ", beta[0])))
plot_beta1 + theme(text=element_text(family="Verdana", size=14))
plot_beta2 <- plot_beta[[2]] + ggtitle(expression(paste("Comparison for beta fields: ", beta[1])))
plot_beta2 + theme(text=element_text(family="Verdana", size=14))
plot_beta3 <- plot_beta[[3]] + ggtitle(expression(paste("Comparison for beta fields: ", beta[2])))
plot_beta3 + theme(text=element_text(family="Verdana", size=14))

# plot predictions

## cross-validation

# create the CV structure defining 10 different CV-groups
Ind.cv <- createCV(mdb.model, groups = 10, min.dist = 0.1)

# find out which location belongs to which cv group
I.col <- apply(sapply(Ind.cv,function(x) mdb.model$locations$ID
                               %in% x), 1, function(x) if(sum(x)==1) which(x) else 0)
names(I.col) <- mesa.model$locations$ID

