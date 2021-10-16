# Clear memory
rm(list = ls(all=TRUE))

# import default proj dir and Check path contents
path <- setwd("D:/STUDY/4.GIS/G I S 4.2/0.Project/ModelsAlgorithmsCodes/6.Accurcay Assesment")
path
contents <- length(list.files(path))
contents

data <- read.csv("Correlation2015.csv")
summary(data)
plot(data$L8.Chl.a.Estimates, data$S3.OLCI.Chl.a..Reference.)

# Build the Prediction(Correlation Model)
## The model is : y = mx + c
# Start by partitioning the data

randomNums1 = runif(100)
