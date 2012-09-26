# sweep out the column means
met <- apply(hqmr.new, 2, mean)
F <- sweep(hqmr.new, 2, met)

R <- t(F) %*% F
dim(R)
eof <-  eigen(R)
head(eof$values)
