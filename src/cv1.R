HeatStruct(hqmr.cube.reorder)+opts(axis.text.x = NULL)+geom_hline(yintercept = c(325, 900), col = "darkblue", lwd=1)+geom_vline(xintercept = c(17.5, 54.5), col="darkblue", lwd=1)
xx <- data.frame(x=c(0, 54.5), y=c(900, 900))
xx2 <- data.frame(x=c(0, 54.5), y=c(350, 350))
## 1 year
set.seed(100)
s <- sample(1:ncol(hqmr.cube), 78)
s1 <- s[1:10]
r1 <- 1:12
md.cv <- hqmr.cube # a copy of hqmr.cube

cv1 <- hqmr.cube[r1, s1]
md.cv[r1, s1] <- NA
md.cv$date <- date.month


# apply CUTOFF method 
cvnew1 <- CutIm3(md.cv, 0.75)
cv1.new <- cvnew1[r1, s1]
cv_err1 <- as.matrix(cv1-cv1.new)
cv.rmse1 <- sqrt(sum((as.vector(cv_err1))^2, na.rm = TRUE) / (length(as.vector(cv_err1))-nmissing(cv_err1)))
cv.rmse1
# [1] 0.5490338

## 3 years

set.seed(100)
s2 <- sample(1:ncol(hqmr.cube), 8)
r2 <- 1:36
md.cv <- hqmr.cube # a copy of hqmr.cube

cv2 <- hqmr.cube[r2, s2]
md.cv[r2, s2] <- NA
md.cv$date <- date.month


# apply CUTOFF method 
cvnew2 <- CutIm3(md.cv, 0.75)
cv2.new <- cvnew2[r2, s2]
cv_err2 <- as.matrix(cv2-cv2.new)
cv.rmse2 <- sqrt(sum((as.vector(cv_err2))^2, na.rm = TRUE) / (length(as.vector(cv_err2))-nmissing(cv_err2)))
cv.rmse2
# [1] 0.5959159

## 5 years
set.seed(100)
s3 <- sample(1:ncol(hqmr.cube), 8)
r3 <- 1:60
md.cv <- hqmr.cube # a copy of hqmr.cube

cv3 <- hqmr.cube[r3, s3]
md.cv[r3, s3] <- NA
md.cv$date <- date.month


# apply CUTOFF method 
cvnew3 <- CutIm3(md.cv, 0.75)
cv3.new <- cvnew3[r3, s3]
cv_err3 <- as.matrix(cv3-cv3.new)
cv.rmse3 <- sqrt(sum((as.vector(cv_err3))^2, na.rm = TRUE) / (length(as.vector(cv_err3))-nmissing(cv_err3)))
cv.rmse3
# [1] 0.6274043

## 10 years
set.seed(100)
s4 <- sample(1:ncol(hqmr.cube), 8)
r4 <- 1:120
md.cv <- hqmr.cube # a copy of hqmr.cube

cv4 <- hqmr.cube[r4, s4]
md.cv[r4, s4] <- NA
md.cv$date <- date.month


# apply CUTOFF method 
cvnew4 <- CutIm3(md.cv, 0.75)
cv4.new <- cvnew4[r4, s4]
cv_err4 <- as.matrix(cv4-cv4.new)
cv.rmse4 <- sqrt(sum((as.vector(cv_err4))^2, na.rm = TRUE) / (length(as.vector(cv_err4))-nmissing(cv_err4)))
cv.rmse4
# [1] 0.6169982