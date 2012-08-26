# 100 simulation missing data matrix, apply the CUTOFF method in a cutoff range 
# from 0.55 to 0.95 by 0.005
# get the Mean-RMSE for every cutoff value, and for every imputed data matrix

# get 100 simulation missing matrices

n.sim <-1000 # number of simulations
sim.cutoff <- vector("list", n.sim)
sim.svd <- vector("list", n.sim)
set.seed(100)

system.time(for (i in seq_len(n.sim)){  
  sim.cutoff[[i]] <- BlockMissing()
  sim.svd[[i]] <- sim.cutoff[[i]]
  sim.cutoff[[i]]$date <- date.month[325:900]
})
# check if they are identical 
# identical(sim.svd[[3]], sim.cutoff[[3]][, -79])
library(SpatioTemporal)
system.time(cutoff1000 <- lapply(sim.cutoff, FUN = Cut))
system.time(svd1000 <- lapply(sim.svd, FUN = svd.miss))

# evaluting Mean-RMSE for SVD method
RMSE.svd <- numeric(n.sim)
RMSE.cutoff <- numeric(n.sim)

for (i in seq_len(n.sim)){
  err1 <- as.matrix(svd1000[[i]] - complete.chunk)
  err2 <- as.matrix(cutoff1000[[i]] - complete.chunk)
  n <- nmissing(sim.svd[[i]])
  
  RMSE.svd[i] <- sqrt(sum(err1^2) / n)
  RMSE.cutoff[i] <- sqrt(sum(err2^2) / n)
}
RMSE1000 <- mapply(mean, list(RMSE.svd, RMSE.cutoff))

# some repetitive code that I don't like, but anyway, run!
n.sim <-500 # number of simulations
sim.cutoff <- vector("list", n.sim)
sim.svd <- vector("list", n.sim)
set.seed(100)

system.time(for (i in seq_len(n.sim)){  
  sim.cutoff[[i]] <- BlockMissing()
  sim.svd[[i]] <- sim.cutoff[[i]]
  sim.cutoff[[i]]$date <- date.month[325:900]
})
# check if they are identical 
# identical(sim.svd[[3]], sim.cutoff[[3]][, -79])
library(SpatioTemporal)
system.time(cutoff500 <- lapply(sim.cutoff, FUN = Cut))
system.time(svd500 <- lapply(sim.svd, FUN = svd.miss))

# evaluting Mean-RMSE for SVD method
RMSE.svd <- numeric(n.sim)
RMSE.cutoff <- numeric(n.sim)

for (i in seq_len(n.sim)){
  err1 <- as.matrix(svd500[[i]] - complete.chunk)
  err2 <- as.matrix(cutoff500[[i]] - complete.chunk)
  n <- nmissing(sim.svd[[i]])
  
  RMSE.svd[i] <- sqrt(sum(err1^2) / n)
  RMSE.cutoff[i] <- sqrt(sum(err2^2) / n)
}
RMSE500 <- mapply(mean, list(RMSE.svd, RMSE.cutoff))
#
n.sim <-50 # number of simulations
sim.cutoff <- vector("list", n.sim)
sim.svd <- vector("list", n.sim)
set.seed(100)

system.time(for (i in seq_len(n.sim)){  
  sim.cutoff[[i]] <- BlockMissing()
  sim.svd[[i]] <- sim.cutoff[[i]]
  sim.cutoff[[i]]$date <- date.month[325:900]
})
# check if they are identical 
# identical(sim.svd[[3]], sim.cutoff[[3]][, -79])
library(SpatioTemporal)
system.time(cutoff50 <- lapply(sim.cutoff, FUN = Cut))
system.time(svd50 <- lapply(sim.svd, FUN = svd.miss))

# evaluting Mean-RMSE for SVD method
RMSE.svd <- numeric(n.sim)
RMSE.cutoff <- numeric(n.sim)

for (i in seq_len(n.sim)){
  err1 <- as.matrix(svd50[[i]] - complete.chunk)
  err2 <- as.matrix(cutoff50[[i]] - complete.chunk)
  n <- nmissing(sim.svd[[i]])
  
  RMSE.svd[i] <- sqrt(sum(err1^2) / n)
  RMSE.cutoff[i] <- sqrt(sum(err2^2) / n)
}
RMSE50 <- mapply(mean, list(RMSE.svd, RMSE.cutoff))

# 100

n.sim <-100 # number of simulations
sim.cutoff <- vector("list", n.sim)
sim.svd <- vector("list", n.sim)
set.seed(100)

system.time(for (i in seq_len(n.sim)){  
  sim.cutoff[[i]] <- BlockMissing()
  sim.svd[[i]] <- sim.cutoff[[i]]
  sim.cutoff[[i]]$date <- date.month[325:900]
})
# check if they are identical 
# identical(sim.svd[[3]], sim.cutoff[[3]][, -79])
library(SpatioTemporal)
system.time(cutoff100 <- lapply(sim.cutoff, FUN = Cut))
system.time(svd100 <- lapply(sim.svd, FUN = svd.miss))

# evaluting Mean-RMSE for SVD method
RMSE.svd <- numeric(n.sim)
RMSE.cutoff <- numeric(n.sim)

for (i in seq_len(n.sim)){
  err1 <- as.matrix(svd100[[i]] - complete.chunk)
  err2 <- as.matrix(cutoff100[[i]] - complete.chunk)
  n <- nmissing(sim.svd[[i]])
  
  RMSE.svd[i] <- sqrt(sum(err1^2) / n)
  RMSE.cutoff[i] <- sqrt(sum(err2^2) / n)
}
RMSE100 <- mapply(mean, list(RMSE.svd, RMSE.cutoff))

# 
n.sim <-5000 # number of simulations
sim.cutoff <- vector("list", n.sim)
sim.svd <- vector("list", n.sim)
set.seed(100)

system.time(for (i in seq_len(n.sim)){  
  sim.cutoff[[i]] <- BlockMissing()
  sim.svd[[i]] <- sim.cutoff[[i]]
  sim.cutoff[[i]]$date <- date.month[325:900]
})
# check if they are identical 
# identical(sim.svd[[3]], sim.cutoff[[3]][, -79])
library(SpatioTemporal)
system.time(cutoff5000 <- lapply(sim.cutoff, FUN = Cut))
system.time(svd5000 <- lapply(sim.svd, FUN = svd.miss))

# evaluting Mean-RMSE for SVD method
RMSE.svd <- numeric(n.sim)
RMSE.cutoff <- numeric(n.sim)

for (i in seq_len(n.sim)){
  err1 <- as.matrix(svd5000[[i]] - complete.chunk)
  err2 <- as.matrix(cutoff5000[[i]] - complete.chunk)
  n <- nmissing(sim.svd[[i]])
  
  RMSE.svd[i] <- sqrt(sum(err1^2) / n)
  RMSE.cutoff[i] <- sqrt(sum(err2^2) / n)
}
RMSE5000 <- mapply(mean, list(RMSE.svd, RMSE.cutoff))