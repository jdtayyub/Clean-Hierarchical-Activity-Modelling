args <- commandArgs(TRUE)
path2Mat <- as.double(args[1])


library(fossil)
library(R.matlab)
data <- readMat(path2Mat)
mat <- data$matrix
tri.ineq(mat)