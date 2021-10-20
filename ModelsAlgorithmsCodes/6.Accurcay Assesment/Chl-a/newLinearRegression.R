# Clear memory
rm(list = ls(all=TRUE))

library(caret)
library(tidyverse)

# import default proj dir and Check path contents
path <- setwd("D:/STUDY/4.GIS/G I S 4.2/0.Project/ModelsAlgorithmsCodes/6.Accurcay Assesment")
Yield = read.csv("Maize Yield April fin.csv") #april data

str(Yield)
colnames(Yield)

#partitioning the data

#random seed
set.seed(1980)

#validation method
fitControll = trainControl(method = "cv", number = 5,
                           savePredictions = TRUE)

#set random seed
set.seed(1980)

#model used -> linear regression
LR <- train(YIELD.MT.ha.~ Rainfall.mm. + Temperature + Wind.Speed.kph. 
            + Air.Pressure.mb., 
            data = Yield,
            method = "glm", trControl = fitControll)

print(LR)
summary(LR)
varImp(LR)

plot(varImp(LR, scale = F), main = "Var Imp: LR 5 fold CV")

#Testing and validation
pd <- predict(LR, newdata = test)
test$predicted <- pd
plot(test$`YIELD(MT/ha)`, test$predicted, ylab = "Predicted yields (T/ha)", 
     xlab = "Measured yields (T/ha)", col = "Blue",  
     pch = 16, xlim = c(1,6), ylim = c(1,6), 
     main = "Linear Regression"); qqline(test$predicted)

#MAPE
library(MLmetrics)
mape_LR = MAPE(LR$pred$pred, LR$pred$obs)

# predictions
Data <- read.csv("2021 weather.csv")
preds_LR <- predict(LR, newdata = Data)
Data$predictedLR <- preds_LR

#saving
write.csv(Data, file = '2021 predictions.csv')
