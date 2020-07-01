library(caret)
library(caretEnsemble)
library(kernlab)
library(gbm)
library(randomForest)

data(iris)
trainIndex <- createDataPartition(iris$Species, p = 0.8, list = FALSE)
train <- iris[trainIndex, ]
validation <- iris[-trainIndex, ]

control <- trainControl(method = "cv", number = 10)

knnModel <- train(Species ~ ., train, method = "knn", metric = "Accuracy", trControl = control)
save(knnModel, file = "knnModel.rda")
svmModel <- train(Species ~ ., train, method = "svmRadial", metric = "Accuracy", trControl = control)
save(svmModel, file = "svmModel.rda")
gbmModel <- train(Species ~ ., train, method = "gbm", metric = "Accuracy", trControl = control, verbose = FALSE)
save(gbmModel, file = "gbmModel.rda")

knnPred <- predict(knnModel, newdata = validation)
svmPred <- predict(svmModel, newdata = validation)
gbmPred <- predict(gbmModel, newdata = validation)

predDF <- data.frame(knnPred, svmPred, gbmPred, Species = validation$Species)

stackedModel <- randomForest(Species ~ ., data = predDF)

save(stackedModel, file = "stackediris.rda")