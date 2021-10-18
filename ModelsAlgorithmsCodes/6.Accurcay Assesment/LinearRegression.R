# Clear memory
rm(list = ls(all=TRUE))
library(ggplot2)

# import default proj dir and Check path contents
path <- setwd("D:/STUDY/4.GIS/G I S 4.2/0.Project/ModelsAlgorithmsCodes/6.Accurcay Assesment")
path
contents <- length(list.files(path))
contents

data <- read.csv("Correlation2018.csv")
summary(data)
plot(data$L8.Chl.a.Estimates, data$S3.OLCI.Chl.a..Reference.)

# Build the Prediction(Correlation Model)
## The model is : y = mx + c
# Start by partitioning the data into train and test 

randomNums1 = runif(60)

# Index the radon numbers
indexedData <- order(randomNums1)

# Create training dataset with the first 20 records in the shuffle
training <- data[indexedData[1:45],]

# Test dataset
test_ds = data[indexedData[46:60],]

# Build the prediction linear model
regressor <- lm(S3.OLCI.Chl.a..Reference.~L8.Chl.a.Estimates, data = training)
## abline plot
abline(regressor, col = "red")

## Model summary
summary(regressor)

# Regression line
# y = 6.05839 + 0.074977(l8)

## Plotting predictions of the values
# plot(regressor)

## Customize your plots from here using ggplot2
