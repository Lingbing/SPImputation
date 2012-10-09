################## key functions for the rainfall modeling project ######################
#                                  19/07/2012                                           #
#########################################################################################

Nmissing <- function(x) {
  colSums(is.na(x))
}

nmissing <- function(x) sum(is.na(x)) 
Nnan <- function(x) sum(is.nan(x))

svd.miss <- function(x){
  # use SVD method, return the imputed complete data matrix
  
  require(SpatioTemporal)
  SVD.miss(x)$Xfill
}

find.id <- function(x, cutoff, ...) {
  cor <- cor(x, use = "complete")
  diag(cor) <- 0
  
  for (i in 1:ncol(x)){    
    id[i] <- sum(cor[, i] >= cutoff)
  }
  
  return(id)
}


findmax <- function(x, r){
  # x is a data matrix, e.g. a correlation matrix
  # r is a value to be compared
  # compare the maximum value of every column of x with r, find which coloumn has no values bigger than r
  
  library(plyr)
  
  if(!is.data.frame(x)){
    x <- as.data.frame(x)
  }
  p <- colwise(max)(as.data.frame(x))
  
  if(all(p >= r)) {
    cat("Every column has value(s) bigger than", r, "\n")
    return(0)
  }  
  else{
    return(which(p < r))
  }
}


VarInfo <- function(x, type = "NA"){
  
  # this function caculate the number of NAs or Zeros in a vector or data matrix
  # type: "NA" for NAs, "zero" for Zeros
  
  if(type == "NA"){D <- is.na(x)}
  if(type == "zero"){D = (x == 0)}
  if (type != "NA" & type != "zero") {
    print("You made a typo, type must be NA or zero")} else {colSums(D, na.rm = TRUE)}
  
}

grid.rmse <- function(x, x1){
  err <- as.matrix(x-x1)
  
  rmse <- sqrt((sum((as.vector(err)^2), na.rm = TRUE)) / (length(as.vector(err)) - nmissing(err)))
  return(rmse)
}


HeatStruct <- function (data, high.col = "darkgreen", missing.col = "red", xlab = "stations", ylab = "Months" ){
  
  #  This is a function to inspect the structure of a data matrix, data could be a data frame or a matrix
  #  Like a heatmap for dataframe, but particulary useful to draw out the missing value pattern 
  #  high.col: colour for the values, default is "darkgreen"; low values have been set to be white 
  #  missing.col: colour for missing values, default is "red"
  #  all ggplot routines can be added to polish this plot, e.g. use + labs("stations", "Months") to add labels
  #  xlab and ylab are for labelling the axies
  require(ggplot2)
  if(!is.data.frame(data)){
    data <- as.data.frame(data)
  }
  
  ggpcp(data) +
    aes_string(y = "ROWID", fill = "value", x = "variable") +
    geom_tile() +
    scale_y_continuous(expand=c(0, 1)) +
    scale_fill_continuous(low = "white", high = high.col, na.value = missing.col, guide="colorbar") +
    labs(x = xlab, y = ylab)
}




MissSimulation <- function(n = 84, maxlen = 15, cnst = 15, prob = 0.03){
  
  #  This is a function to simulate the block missing pattern in one column
  #  any point in the colum has a small probability (the "prob" argument) of being missing, once it's missed, points close to it would have a higher probabilyty of being missing
  
  #  to get a block missing pattern data matrix, we need to use this function many times
  #  n: the number of blocks in that colum, here we assue a season block which means a block is actually 3 months, thus 3 obs for monthly data
  #  maxlen: the maximum length we assume the simulated column might have, default to be 15, 
  #  prob is the missing probability for any point in the column
  
  rec <- rep(NA, n)
  
  for (i in 1:length(rec)){
    
    if (i==1) {
      rec[i] <- count <- rbinom(1, 1, prob)
    }
    if (count == maxlen) {
      rec[i] <- count <- 0
    } 
    else if (count == 0) {
      rec[i] <- count <- rbinom(1, 1, prob)
    } 
    else {
      rec[i] <- rbinom(1, 1, (count + cnst)/(maxlen + cnst))
      count <- count + rec[i]
    }
    
  }
  return(rec)
}


BlockMissing <- function() {
  # This is the function to do the whole block missing simulation
  # apply "part.sim" function to simulate each seperately and then combine them to a whole matrix 
  # p1(), p2(), p3(), p4() are four sub-matrix simulation functions
  
  block.size <- 3 # scale for blocks when simulating the first part
  n.years <- c(12, 36, 48, 48)  # number of years for four simulation parts
  n.stations <- c(17, 17, 37, 24)  # number of stations for four simulation parts
  n.prob <- c(0.05, 0.005, 0.005, 0.0005) # probability vector for each simulation part
  
  part1.sim <- function() MissSimulation(n = 4*n.years[1], maxlen=12, cnst=12, n.prob[1])
  part2.sim <- function() MissSimulation(n = 12*n.years[2], maxlen=3, cnst=3, n.prob[2])
  part3.sim <- function() MissSimulation(n = 12*n.years[3], maxlen=3, cnst=3, n.prob[3])
  part4.sim <- function() MissSimulation(n = 12*n.years[4], maxlen=3, cnst=3, n.prob[4])
  
  p1 <- function(){
    # simulate missing matrix part1
    # this part is the most complicated part 
    
    part1.mat <- matrix(0, nrow = 4*n.years[1], ncol = n.stations[1])
    
    for (j in 1:length(part1.mat[1, ])){
      
      part1.mat[, j] <- part1.sim()
      part1.missing.mat <- matrix(0, nrow = 12*n.years[1], ncol = n.stations[1])
      
      # each block value should repeate three times to get the true missing matrix  
      part1.missing.mat[1:nrow(part1.missing.mat), ] <- part1.mat[rep(1:nrow(part1.mat), each=block.size), ]
      part1.missing.mat[part1.missing.mat==1] <- NA
      
    }
    
    return(p1.miss = part1.missing.mat)
  }
  
  p2 <- function(){
    # simulate missing matrix part2
    
    part2.mat <- matrix(0, nrow=12*n.years[2], ncol=n.stations[2])
    
    for (j in 1:length(part2.mat[1, ])){
      
      part2.mat[, j] <- part2.sim()
      part2.missing.mat <- part2.mat
      part2.missing.mat[part2.missing.mat==1] <- NA  
    }
    
    return(p2.miss = part2.missing.mat)
  }
  
  p3 <- function(){
    # simulate missing matrix part3
    
    part3.mat <- matrix(0, nrow=12*n.years[3], ncol=n.stations[3])
    
    for (j in 1:length(part3.mat[1, ])){
      
      part3.mat[, j] <- part3.sim()
      part3.missing.mat <- part3.mat
      part3.missing.mat[part3.missing.mat==1] <- NA  
    }
    
    return(p3.miss = part3.missing.mat)
  }
  
  p4 <- function(){
    # simulate missing matrix part3
    
    part4.mat <- matrix(0, nrow=12*n.years[4], ncol=n.stations[4])
    
    for (j in 1:length(part4.mat[1, ])){
      
      part4.mat[, j] <- part4.sim()
      part4.missing.mat <- part4.mat
      part4.missing.mat[part4.missing.mat==1] <- NA  
    }
    
    return(p4.missing=part4.missing.mat)
  }
  
  # combile the four parts of missing matrices into one complete missing simulation matrix
  # Plusing the complete missing matrix with the complete data matrix will get the simulation matrix with real values 
  # be watchful on using "rbind(p2(), p1)" 
  return(complete.sim = as.data.frame(cbind(rbind(p2(), p1()), cbind(p3(),p4()))) + complete.chunk)
}


Cut <- function(data, cutoff = 0.75, ID = FALSE,  ...) {
  
  # This function imputed missing values in data by CUTOFF method.
  # the default cutoff value is 0.75, could be altered.
  # data is required to have a date variable in the last column with format including year&month information
  # date: the name of the date variable
  # id: if set TRUE, then return the reference id for each station when imputing, default is FALSE
  
  # require(lubridate)
  chunk <- as.matrix(subset(data, select = - date))  # put off the date column
  cor_matrix <- cor(chunk, use = "complete.obs") # casewise deletion to compute correlation matrix
  diag(cor_matrix) <- 0 
  dimnames(cor_matrix) <- NULL
  
  year <- 1900 + as.POSIXlt(data$date)$year  #  the year information-
  month <- 1 + as.POSIXlt(data$date)$mon  # the month info
  
  rainfall_new <- chunk  
  nc <- ncol(rainfall_new)
  nr <- nrow(rainfall_new)
  id <- vector("list", nc) # record the reference ids
  
  for(j in 1:nc)
  {
    if(any(cor_matrix[, j] >= cutoff)){
      
      R_id <- which(cor_matrix[, j] >= cutoff)  # R.id is the ids of reference stations  
    }
    else {
      big <- max(cor_matrix[, j])
      R_id <- which(cor_matrix[, j] == big)
    }
    
    for(i in 1:nr)
    {
      if (is.na(rainfall_new[i, j]))  # only impute missing values
      {
        C_id <- which(year != year[i] & month == month[i])  #  condidate ids
        C_bar_data <- chunk[C_id, j]
        C_bar <- mean(C_bar_data, na.rm = TRUE)  # condidate mean (C bar in the equation), removing NAs is essential!
        
        R_bar_data <- chunk[C_id, R_id]  # reference data
        R_bar <- mean(as.vector(R_bar_data), na.rm=TRUE)  # reference mean (R bar in the equation)
        
        R_ix <- which(year == year[i] & month == month[i])
        R_data <- chunk[R_ix, R_id]
        
        if(!all(is.na(R_data))){
          # if in that month and year, not all obs in the the reference station(s) are missing 
          # then the imputation succeeds. 
          R <- mean(as.vector(R_data), na.rm=TRUE)  # term R in the equation
        }
        else{ 
          
          find.na <- function(x){
            # find the first non-NA in a vector
            for (i in 1:length(x))
              while(!is.na(x[i]))
                return(x[i])
          }
          
          idj <- order(cor_matrix[, j], decreasing = TRUE)
          rvec <- as.vector(chunk[R_ix, idj])
          r <- find.na(rvec)
          R <- r
        }
        rainfall_new[i, j] <- R*C_bar/R_bar  # implementation of the CUTOFF method
        
      }
      if(ID){
        id[[j]] <- R_id
      }    
    }
    
  }
 
  if(ID){
    return(list(imputed = rainfall_new, ID = id))
  }
  else{
    return(rainfall_new)  
  } 
}


cut.cv <- function(data, cut = 0.75, grid.size = 1, ...){
  # cross-validation function
  
  grid.rmse <- function(x, x1){
    # intermediate function for cumputing rmse, given two matrices: matrix 1
    # with missing and matrix 2 with imputed values. 
    err <- as.matrix(x-x1)    
    rmse <- sqrt((sum((as.vector(err)^2), na.rm = TRUE)) / (length(as.vector(err)) - nmissing(err)))
    return(rmse)
  }
  
  # resample the columns
  s <- sample(1:ncol(data), ncol(data))
  r <- sample(1:nrow(data), nrow(data))
  date_month <- date.month[r]
  # devide in to 10 folds  
  md.cv <- data[r, s]
  i_seq <- seq(1, nrow(md.cv), by = (grid.size * 12))
  j_seq <- seq(1, ncol(md.cv), by = 8)
  cv.rmse <- matrix(0, length(i_seq), length(j_seq))
  
  for (j in j_seq){
    for(i in i_seq){
      
      m <- (i %/% (grid.size * 12)) + 1
      n <- (j %/% 8) + 1
      
      if(n <= 9){
        grid <- md.cv[i:(i + (grid.size * 12 - 1)), j:(j + 7)]
        grid.old <- grid
        
        md.na <- md.cv
        md.na[i:(i + (grid.size * 12 - 1)), j:(j + 7)] <- NA
        md.na$date <- date_month
        md.new <- Cut(md.na, cutoff = cut)
        
        grid.new <- md.new[i:(i + (grid.size * 12 - 1)), j:(j + 7)]
        cv.rmse[m, n] <- grid.rmse(grid.new, grid.old)
      }
      else{
        grid <- md.cv[i:(i + (grid.size * 12 - 1)), j:(j + 5)]
        grid.old <- grid
        
        md.na <- md.cv
        md.na[i:(i + (grid.size * 12 - 1)), j:(j + 5)] <- NA     
        md.na$date <- date.month
        md.new <- Cut(md.na, cutoff = cut)
        
        grid.new <- md.new[i:(i + (grid.size * 12 - 1)), j:(j + 5)]  
        cv.rmse[m, n] <- grid.rmse(grid.new, grid.old)
      }      
    }
  }
  return(rmse = as.vector(cv.rmse))
}

# plot functions
implot <- function(i = 1, start = "1911-01-01", end = "2010-12-01", oridata = hqmr.reorder, impdata = hqmr.new, iso = TRUE, ..., pch = 21, cex = 0.5){
  
  require(ggplot2)
  
  x <- as.data.frame(cbind(oridata[, i], impdata[, i]))
  x$month <- date.month
  nn <- is.na(x$V1)
  x.na <- x[, -1]
  x.na[!nn, 1] <- NA
  
  p <- ggplot(x, aes(month, V1)) + geom_line()
  
  if(iso) {
    p <- p + geom_line(data = x.na, aes(month, V2), col = "red", lty = 2) +
      geom_point(data = x.na, aes(month, V2), col = "red", pch = pch, cex = cex) +
      ylab("Rainfall")
    p <- p + scale_x_date(limits = c(as.Date(start), as.Date(end)))
  }
  
  else {
    p <- p + geom_line(data = x.na, aes(month, V2), col = "red", lty = 2) + ylab("Rainfall")
    p <- p + scale_x_date(limits = c(as.Date(start), as.Date(end)))
  }
  p
}

implot2 <- function(x){
  require(grid)
  len <- length(x)
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(len, 1)))
  vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
  
  for (i in 1:len){
    print(x[[i]], vp = vplayout(i, 1))
  }
}



