# 100 simulation missing data matrix, apply the CUTOFF method in a cutoff range 
# from 0.55 to 0.95 by 0.005
# get the Mean-RMSE for every cutoff value, and for every imputed data matrix

# get 100 simulation missing matrices

n.sim <-100  # number of simulations
sim.cutoff <- vector("list", n.sim)
sim.svd <- vector("list", n.sim)
set.seed(100)

for (i in seq_len(n.sim)){  
  sim.cutoff[[i]] <- BlockMissing()
  sim.svd[[i]] <- sim.cutoff[[i]]
  sim.cutoff[[i]]$date <- date.month[325:900]
}
# check if they are identical 
# identical(sim.svd[[3]], sim.cutoff[[3]][, -79])
library(SpatioTemporal)
system.time(cutoff100 <- lapply(sim.cutoff, FUN = Cut))
system.time(svd100 <- lapply(sim.svd, FUN = svd.miss))

# evaluting Mean-RMSE for SVD method
RMSE.svd <- numeric(n.sim)
for (i in seq_len(n.sim)){
  err <- as.matrix(svd100[[i]] - complete.chunk)
  n <- nmissing(sim.svd[[i]])
  RMSE.svd[i] <- sqrt(sum(err^2) / n)
}