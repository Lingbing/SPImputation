# check the BlockMissing() function, inspect the missing patter
library(multicore)
# HeatStruct(BlockMissing(), high.col = "darkgreen", missing.col = "red") 

n.sim <-100  # number of simulations
set.seed(100)
sim.cutoff <- vector("list", n.sim)
for (i in 1:n.sim){
  sim.cutoff[[i]] <- BlockMissing()
  sim.cutoff[[i]]$date <- date.month[325:900]
}



Rmse <- function(cut.value = 0.75, ...){
  # 
  com <- mclapply(sim.cutoff, FUN = Cut, cutoff = cut.value)  
  RMSE <- numeric(n.sim)
  
  for (i in seq_len(n.sim)){
    err <- as.matrix(com[[i]] - complete.chunk)
    n <- nmissing(sim.cutoff[[i]])
    RMSE[i] <- sqrt(sum(err^2) / n)
  }
  return(RMSE)
}

Rmse()
# try
# set.seed(100)
# mean(cutoff.rmse(0.75))
cut <- seq(0.45, 0.95, by=0.001)
try <- mapply(cutoff.rmse, cut.value = cut)
cutoff.cv <- apply(try, 2, mean)
cutoff.sd <- apply(try, 2, sd)

x <- as.data.frame(cbind(cut, cutoff.cv))
x <- transform(x, ymax =  cutoff.cv + cutoff.sd, ymin = cutoff.cv - cutoff.sd)
limits <- aes(ymax=ymax, ymin=ymin)  # for errorbar plot
minimal <- subset(x, cutoff.cv == min(cutoff.cv))
p <- ggplot(x, aes(x = cut, y = cutoff.cv)) + geom_line() +
  geom_point(data = minimal, size = 3, colour = "red") +
  geom_errorbar(limits, col = "grey", lty = 5)
p <- p + geom_abline(intercept = 0.6433, slop = 0, lty = 2, size = 0.9, colour = "darkgreen")
p <- p + xlab("CUTOFF value") + ylab("Mean-RMSE") + theme_grey(base_size = 12)
p <- p + annotate("text", x = 0.68, y = 0.66, label= "RMSE(SVD) = 0.6433", col= "darkgreen")
p + scale_x_continuous(breaks = seq(0.45, 0.95, by = 0.05))
# p <- p + annotate("text", x = 0.65, y = 0.545, label= "min-RMSE(CUTOFF) = 0.5367", col= "blue")
# p <- p+annotate("text", x= 0.763, y = 0.53, label="0.763")
# p <- p+annotate("rect", xmin = 0.768, xmax = 0.9, ymin = 0.537, ymax = 0.59, alpha=0.2)
p


  

