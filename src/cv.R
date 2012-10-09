# parallel computing 
# registering front-ends for foreach()
library(doParallel)
cl <- makeCluster(8)
registerDoParallel(cl)

cut <- seq(0.55, 0.95, by = 0.005) # cutoff values from 0.55 to 0.85
set.seed(100)

# grid.size = 1
system.time(cv1.mat_2 <- 
  foreach (i = seq_along(cut), .combine = cbind) %dopar% {
    cut.cv(hqmr.cube, cut = cut[i], 1)
  })
# grid.size = 10
system.time(cv10.mat_2 <- 
foreach (i = seq_along(cut), .combine = cbind) %dopar% {
  cut.cv(hqmr.cube, cut = cut[i], 10)
})

# grid.size = 5
system.time(cv5.mat_2 <- 
  foreach (i = 1:length(cut), .combine = cbind) %dopar% {
    cut.cv(hqmr.cube, cut = cut[i], 5)
  })

library("ggplot2"); library("reshape2")
library("scales")# for the alpha() function
mean_2.cv1 <- apply(cv1.mat_2, 2, mean, na.rm = TRUE)
mean_2.cv5 <- apply(cv5.mat_2, 2, mean, na.rm = TRUE)
mean_2.cv10 <- apply(cv10.mat_2, 2, mean, na.rm = TRUE)
# sd2.cv1 <- apply(cv1.mat2, 2, sd, na.rm = TRUE)
# sd2.cv5 <- apply(cv5.mat2, 2, sd, na.rm = TRUE)
# sd2.cv10 <- apply(cv10.mat2, 2, sd, na.rm = TRUE)
cv_2 <- as.data.frame(cbind(cut,mean_2.cv1, mean_2.cv5, mean_2.cv10))
# cv_sd <- transform(cv, ymax_5 = mean.cv5 + sd.cv5, ymin_5 = mean.cv5 - sd.cv5, ymax_10 = mean.cv10 + sd.cv10, ymin_10 = mean.cv10 - sd.cv10)

names(cv_2) <- c("cutoff", "grid_1", "grid_5", "grid_10")
melt.cv_2 <- melt(cv_2, id="cutoff")
names(melt.cv_2) <- c("cutoff", "grid.size", "RMSE")
minimal <- subset(melt.cv_2[melt.cv_2$grid.size == "grid_1", ], RMSE == min(RMSE))
minimal2 <- subset(melt.cv_2[melt.cv_2$grid.size == "grid_5", ], RMSE == min(RMSE))
minimal3 <- subset(melt.cv_2[melt.cv_2$grid.size == "grid_10", ], RMSE == min(RMSE))


p2 <- ggplot(melt.cv_2, aes(cutoff, RMSE, colour=grid.size, linetype = grid.size)) +
  geom_line() + scale_colour_manual(values=c("darkgreen", "black", "red"))
cv_plot <- p2 + geom_point(data = minimal, size = 3, colour = alpha("darkgreen", 0.5)) +
  geom_point(data = minimal2, size = 3, colour = alpha("black", 0.5))+
  geom_point(data = minimal3, size = 3, colour = alpha("red", 0.5)) +
  geom_vline(xintercept = 0.76, lty = 6, col = "blue")
## classical for loops
# cv11.mat <- matrix(0, 1000, length(cut))
# set.seed(100)
# system.time(
#   for (i in 1:length(cut)) {
#     cv11.mat[, i] <- cut.cv(hqmr.cube, cut = cut[i], 1)
#   })
set.seed(1)
system.time(cv5.mat2 <- 
  foreach (i = 1:length(cut), .combine = cbind) %dopar% {
    cut.cv(hqmr.cube, cut = cut[i], 5)
  })


