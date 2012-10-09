
# get the Mean-RMSE for every cutoff value, and for every imputed data matrix


# simulation = 50 
library(SpatioTemporal) # we need the function SVD.miss in this pkg
library(multicore) # multicore computing is faster, NOT available in Window

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
# system.time(cutoff50 <- lapply(sim.cutoff, FUN = Cut))
# try multicore computingm it's faster

system.time(cutoff50 <- mclapply(sim.cutoff, FUN = Cut))
system.time(svd50 <- mclapply(sim.svd, FUN = svd.miss))

# evaluting Mean-RMSE for SVD method
RMSE50.svd <- numeric(n.sim)
RMSE50.cutoff <- numeric(n.sim)

for (i in seq_len(n.sim)){
  err1 <- as.matrix(svd50[[i]] - complete.chunk)
  err2 <- as.matrix(cutoff50[[i]] - complete.chunk)
  n <- nmissing(sim.svd[[i]])
  
  RMSE50.svd[i] <- sqrt(sum(err1^2) / n)
  RMSE50.cutoff[i] <- sqrt(sum(err2^2) / n)
}
RMSE50 <- mapply(mean, list(RMSE50.svd, RMSE50.cutoff))
sd50 <- mapply(sd, list(RMSE50.svd, RMSE50.cutoff))

# simulation 100
n.sim <-100 
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

system.time(cutoff100 <- mclapply(sim.cutoff, FUN = Cut))
system.time(svd100 <- mclapply(sim.svd, FUN = svd.miss))

# evaluting Mean-RMSE for SVD method
RMSE100.svd <- numeric(n.sim)
RMSE100.cutoff <- numeric(n.sim)

for (i in seq_len(n.sim)){
  err1 <- as.matrix(svd100[[i]] - complete.chunk)
  err2 <- as.matrix(cutoff100[[i]] - complete.chunk)
  n <- nmissing(sim.svd[[i]])
  
  RMSE100.svd[i] <- sqrt(sum(err1^2) / n)
  RMSE100.cutoff[i] <- sqrt(sum(err2^2) / n)
}
RMSE100 <- mapply(mean, list(RMSE100.svd, RMSE100.cutoff))
sd100 <- mapply(sd, list(RMSE100.svd, RMSE100.cutoff))

# some repetitive code that I don't like, but anyway, run!
# simulation = 500
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

system.time(cutoff500 <- mclapply(sim.cutoff, FUN = Cut))
system.time(svd500 <- mclapply(sim.svd, FUN = svd.miss))

# evaluting Mean-RMSE for SVD method
RMSE500.svd <- numeric(n.sim)
RMSE500.cutoff <- numeric(n.sim)

for (i in seq_len(n.sim)){
  err1 <- as.matrix(svd500[[i]] - complete.chunk)
  err2 <- as.matrix(cutoff500[[i]] - complete.chunk)
  n <- nmissing(sim.svd[[i]])
  
  RMSE500.svd[i] <- sqrt(sum(err1^2) / n)
  RMSE500.cutoff[i] <- sqrt(sum(err2^2) / n)
}

RMSE500 <- mapply(mean, list(RMSE500.svd, RMSE500.cutoff))
sd500 <- mapply(sd, list(RMSE500.svd, RMSE500.cutoff))


# simulation = 1000

n.sim <-1000 
sim.cutoff <- vector("list", n.sim)
sim.svd <- vector("list", n.sim)
set.seed(100)

system.time(for (i in seq_len(n.sim)){  
  sim.cutoff[[i]] <- BlockMissing()
  sim.svd[[i]] <- sim.cutoff[[i]]
  sim.cutoff[[i]]$date <- date.month[325:900]
})

system.time(cutoff1000 <- mclapply(sim.cutoff, FUN = Cut))
system.time(svd1000 <- mclapply(sim.svd, FUN = svd.miss))

# evaluting Mean-RMSE for SVD method
RMSE1000.svd <- numeric(n.sim)
RMSE1000.cutoff <- numeric(n.sim)

for (i in seq_len(n.sim)){
  err1 <- as.matrix(svd1000[[i]] - complete.chunk)
  err2 <- as.matrix(cutoff1000[[i]] - complete.chunk)
  n <- nmissing(sim.svd[[i]])
  
  RMSE1000.svd[i] <- sqrt(sum(err1^2) / n)
  RMSE1000.cutoff[i] <- sqrt(sum(err2^2) / n)
}
RMSE1000 <- mapply(mean, list(RMSE1000.svd, RMSE1000.cutoff))
sd1000 <- mapply(sd, list(RMSE1000.svd, RMSE1000.cutoff))

# simulation = 5000
n.sim <-5000 
sim.cutoff <- vector("list", n.sim)
sim.svd <- vector("list", n.sim)
set.seed(100)

system.time(for (i in seq_len(n.sim)){  
  sim.cutoff[[i]] <- BlockMissing()
  sim.svd[[i]] <- sim.cutoff[[i]]
  sim.cutoff[[i]]$date <- date.month[325:900]
})

system.time(cutoff5000 <- mclapply(sim.cutoff, FUN = Cut))
system.time(svd5000 <- mclapply(sim.svd, FUN = svd.miss))

# evaluting Mean-RMSE for SVD method
RMSE5000.svd <- numeric(n.sim)
RMSE5000.cutoff <- numeric(n.sim)

for (i in seq_len(n.sim)){
  err1 <- as.matrix(svd5000[[i]] - complete.chunk)
  err2 <- as.matrix(cutoff5000[[i]] - complete.chunk)
  n <- nmissing(sim.svd[[i]])
  
  RMSE5000.svd[i] <- sqrt(sum(err1^2) / n)
  RMSE5000.cutoff[i] <- sqrt(sum(err2^2) / n)
}
RMSE5000 <- mapply(mean, list(RMSE5000.svd, RMSE5000.cutoff))
sd5000 <- mapply(sd, list(RMSE5000.svd, RMSE5000.cutoff))

# # simulation = 10000
# n.sim <-10000 # number of simulations
# sim.cutoff <- vector("list", n.sim)
# sim.svd <- vector("list", n.sim)
# set.seed(100)
# 
# system.time(for (i in seq_len(n.sim)){  
#   sim.cutoff[[i]] <- BlockMissing()
#   sim.svd[[i]] <- sim.cutoff[[i]]
#   sim.cutoff[[i]]$date <- date.month[325:900]
# })
# # check if they are identical 
# # identical(sim.svd[[3]], sim.cutoff[[3]][, -79])
# library(SpatioTemporal)
# system.time(cutoff10000 <- lapply(sim.cutoff, FUN = Cut))
# system.time(svd10000 <- lapply(sim.svd, FUN = svd.miss))
# 
# # how about a little parallizing
# library(multicore)
# system.time(cutoff10000 <- mclapply(sim.cutoff, Cut))
# system.time(csvd10000 <- mclapply(sim.svd, Cut))
# 
# # evaluting Mean-RMSE for SVD method
# RMSE10000.svd <- numeric(n.sim)
# RMSE10000.cutoff <- numeric(n.sim)
# 
# for (i in seq_len(n.sim)){
#   err1 <- as.matrix(svd10000[[i]] - complete.chunk)
#   err2 <- as.matrix(cutoff10000[[i]] - complete.chunk)
#   n <- nmissing(sim.svd[[i]])
#   
#   RMSE10000.svd[i] <- sqrt(sum(err1^2) / n)
#   RMSE10000.cutoff[i] <- sqrt(sum(err2^2) / n)
# }
# RMSE10000 <- mapply(mean, list(RMSE10000.svd, RMSE10000.cutoff))
# sd10000 <- mapply(sd, list(RMSE10000.svd, RMSE10000.cutoff))