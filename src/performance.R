load("keyobject.Rdata")

# runs <- function(x){
#   diffs <- x[-1L] != x[-length(x)]
#   idx <- c(which(diffs), length(x))
#   diff(c(0, idx))
# }

hqmr.reorder$date <- date.month
system.time(hqmr.new <- Cut(hqmr.reorder, 0.75))
# user  system elapsed 
# 0.42    0.00    0.42 
HeatStruct(hqmr.new)
# we see that the data have been imputed, no missing values anymore.
# next up, visualize the performance.\
x1 <- as.data.frame(cbind(hqmr.cube.reorder[, 1], hqmr.new[, 1]))
x1$month <- date.month
p1 <- ggplot(x1, aes(month, V1)) + geom_line()
p1 + geom_line(data = x1[is.na(x1$V1), ], aes(month, V2), col = "red", lty = 2) +  ylab("Rainfall")



p1 <- implot(1, iso = FALSE, end = "1938-01-01") 
p2 <- implot(2, "1984-01-01")
p3 <- implot(3, "1991-01-01")
p4 <- implot(4, "1998-01-01")
p5 <- implot(5, iso = FALSE, "1995-01-01")
p6 <- implot(6, "1985-01-01") + ylim(c(0, 300))
p7 <- implot(7, "1998-01-01") + ylim(c(0, 300))
p8 <- implot(8, "1990-01-01") + ylim(c(0, 250))
p9 <- implot(9, "1985-01-01") + ylim(c(0, 150))
p10 <- implot(10, "1995-01-01") + ylim(c(0, 250))
p11 <- implot(11, "1928-01-01", "1945-01-01") + ylim (c(0, 180))
p12 <- implot(12, "1985-01-01", "2000-01-01")
p13 <- implot(13, "1992-01-01")
p14 <- implot(14, "1992-01-01")
p15 <- implot(15, "1998-01-01")
p16 <- implot(16, end = "1925-01-01")
p17 <- implot(17, "1994-01-01")
p18 <- implot(18, "1990-01-01")
p19 <- implot(19, "1995-01-01")
p20 <- implot(20, "1982-01-01", "2002-01-01")
p21 <- implot(21, "1995-01-01")
p22 <- implot(22, "2000-01-01")
p23 <- implot(23, "1982-01-01", "2002-01-01")
p24 <- implot(24, "2000-01-01")
# 



implot2(list(p1, p2, p3, p4, p5, p6))
save(imputed_plot1, file="imputed_plot1.Rdata")
implot2(list(p4, p5, p6))
implot2(list(p7, p8, p9))
implot2(list(p10, p11, p12))

### comparison with the SVD method
library(SpatioTemporal)
system.time(hqmr.new2 <- SVDmiss(hqmr.reorder[, -79])$Xfill)
# user  system elapsed 
# 1.72    0.00    1.77




# q1 <- implot(1, impdata = hqmr.new2, end = "1938-01-01") + ylim(c(0, 280))
# q2 <- implot(2, "1984-01-01", impdata = hqmr.new2)
# q3 <- implot(3, "1991-01-01")
# q4 <- implot(4, "1998-01-01")
# q5 <- implot(5, "1995-01-01")
# q6 <- implot(6, "1985-01-01") + ylim(c(0, 300))
# q7 <- implot(7, "1998-01-01") + ylim(c(0, 300))
# q8 <- implot(8, "1990-01-01") + ylim(c(0, 250))
# q9 <- implot(9, "1985-01-01") + ylim(c(0, 150))
# q10 <- implot(10, "1995-01-01") + ylim(c(0, 250))
# q11 <- implot(11, "1928-01-01", "1945-01-01") + ylim (c(0, 180))
# q12 <- implot(12， "1985-01-01", "2000-01-01")
# q13 <- implot(13, "1992-01-01")
# q14 <- implot(14, "1992-01-01")
# q15 <- implot(15, "1998-01-01")
# q16 <- implot(16, end = "1925-01-01")
# q17 <- implot(17, "1994-01-01")
# q18 <- implot(18, "1990-01-01")
# q19 <- implot(19, "1995-01-01")
# q20 <- implot(20, "1982-01-01", "2002-01-01")
# q21 <- implot(21, "1995-01-01")
# q22 <- implot(22, "2000-01-01")
# q23 <- implot(23, "1982-01-01", "2002-01-01")
# q24 <- implot(24, "2000-01-01")
# 
# implot2(list(q1, q2, q3))
# implot2(list(p4, p5, p6))
# implot2(list(p7, p8, p9))
# implot2(list(p10, p11, p12))





# x2 <- as.data.frame(cbind(hqmr.reorder[, 2], hqmr.new[, 2]))
# x2$month <- date.month
# x2_seg <- x2[is.na(x2[, 1]), ]
# x2_seg1 <- x2_seg[1:86, ]
# x2_seg2 <- x2_seg[87, ]
# x2_seg3 <- x2_seg[88, ]
# x2_seg4 <- x2_seg[-(1:89), ]
# p2 <- ggplot(x2, aes(month, V1)) + geom_line()
# p2 + geom_line(data = x2[is.na(x2$V1), ], aes(factor(month), V2, group = 1), col = "red")
# 
# p2 <- p + geom_line(data = x2_seg1, aes(month, V2), col = "red", lty = 2) + ylab("Rainfall")
# p2 <- p + geom_point(data = x2_seg2, aes(month, V2), col = "red", lty = 2) + ylab("Rainfall")
# p2 <- p + geom_point(data = x2_seg3, aes(month, V2), col = "red", lty = 2) + ylab("Rainfall")
# p2 <- p + geom_line(data = x2_seg4, aes(month, V2), col = "red", lty = 2) + ylab("Rainfall")
# p2 <- p + geom_line(data = x2_seg1, aes(month, V2), col = "red", lty = 2) + ylab("Rainfall") +
#   scale_x_date(limits = c(as.Date("1980-01-01"), as.Date("2010-12-01")))
# #
# 
# x3 <- as.data.frame(cbind(hqmr.reorder[, 3], hqmr.new[, 3]))
# x3$month <- date.month
# x3_seg <- x3[is.na(x3[, 1]), ]
# x3_seg1 <- x3_seg[1:86, ]
# x3_seg2 <- x3_seg[87, ]
# x3_seg3 <- x3_seg[88, ]
# x3_seg4 <- x3_seg[-(1:89), ]
# p2 <- ggplot(x3, aes(month, V1)) + geom_line()
# p2 <- p + geom_line(data = x3_seg1, aes(month, V2), col = "red", lty = 2) + ylab("Rainfall")
# p2 <- p + geom_point(data = x3_seg2, aes(month, V2), col = "red", lty = 2) + ylab("Rainfall")
# p2 <- p + geom_point(data = x3_seg3, aes(month, V2), col = "red", lty = 2) + ylab("Rainfall")
# p2 <- p + geom_line(data = x3_seg4, aes(month, V2), col = "red", lty = 2) + ylab("Rainfall")
# p2 <- p + geom_line(data = x3_seg1, aes(month, V2), col = "red", lty = 2) + ylab("Rainfall") +
#   scale_x_date(limits = c(as.Date("1980-01-01"), as.Date("2010-12-01")))
# 


implot3 <- function(i = 1, start = "1911-01-01", end = "2010-12-01", data1 = hqmr.new, data2 = hqmr.new2, col1 = "red", col2 = "darkgreen", ..., pch = 21, cex = 0.8){
  
  require(ggplot2)
  
  x <- as.data.frame(cbind(hqmr.reorder[, i], data1[, i], data2[, i]))
  x$month <- date.month
  nn <- is.na(x$V1)
  x.na <- x[, -1]
  x.na[!nn, 1:2] <- NA
  
  p <- ggplot(x, aes(month, V1)) + geom_line(lwd = 0.5)
  p <- p + geom_line(data = x.na, aes(month, V2), col = col1, lty = 2) +
      geom_line(data = x.na, aes(month, V3), col = col2, lty = 5) + ylab("Rainfall")
  p <- p + scale_x_date(limits = c(as.Date(start), as.Date(end)))
  p <- p + geom_point(data = x.na, aes(month, V2), col = col1, pch = pch, cex = cex)
  p <- p + geom_point(data = x.na, aes(month, V3), col = col2, pch = pch, cex = cex)
  p <- p + scale_x_date(limits = c(as.Date(start), as.Date(end)))
  p
  
}


c1 <- implot3(1, end = "1938-01-01")+ylim(c(0, 280))
c2 <- implot3(2, "1984-01-01")
c3 <- implot3(3, "1991-01-01")
c4 <- implot3(4, "1998-01-01")
c5 <- implot3(5, "1995-01-01")
c6 <- implot3(6, "1985-01-01") + ylim(c(0, 300))
c7 <- implot3(7, "1998-01-01") + ylim(c(0, 300))
c8 <- implot3(8, "1990-01-01") + ylim(c(0, 250))
c9 <- implot3(9, "1985-01-01") + ylim(c(0, 150))
c10 <- implot3(10, "1995-01-01") + ylim(c(0, 250))
c11 <- implot3(11, "1928-01-01", "1945-01-01") + ylim (c(0, 180))
c12 <- implot3(12, "1985-01-01", "2000-01-01")
c13 <- implot3(13, "1992-01-01")
c14 <- implot3(14, "1992-01-01")
c15 <- implot3(15, "1998-01-01")
c16 <- implot3(16, end = "1925-01-01")
c17 <- implot3(17, "1994-01-01")
c18 <- implot3(18, "1990-01-01")
c19 <- implot3(19, "1995-01-01")
c20 <- implot3(20, "1982-01-01", "2002-01-01")
c21 <- implot3(21, "1995-01-01")
c22 <- implot3(22, "2000-01-01")
c23 <- implot3(23, "1982-01-01", "2002-01-01")
c24 <- implot3(24, "2000-01-01")

implot2(list(c1, c2, c3))
implot2(list(C4, C5, C6))
implot2(list(c7, c8, c9))
implot2(list(p10, p11, p12))
