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
# Start by partitioning the data into train and test 

randomNums1 = runif(60)

# Index the radon numbers
shuffle <- order(randomNums1)

# Create training dataset with the first 20 records in the shuffle
training <- data[shuffle[1:30],]

# Test dataset
test_ds = data[shulffle[21:30]]
