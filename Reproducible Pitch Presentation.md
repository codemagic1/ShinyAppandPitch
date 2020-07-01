Reproducible Pitch Presentation
========================================================
author: RK
date: 6/30/2020
width: 1400
height: auto





iris Dataset
========================================================

- Edgar Anderson's Iris Data
- gives measurements in centimetres of the variables sepal length and width and petal length and width for first 50 flowers from each of 3 species of iris


```
  Sepal.Length    Sepal.Width     Petal.Length    Petal.Width   
 Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100  
 1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300  
 Median :5.800   Median :3.000   Median :4.350   Median :1.300  
 Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199  
 3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800  
 Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500  
       Species  
 setosa    :50  
 versicolor:50  
 virginica :50  
                
                
                
```

IrisClassifier Objective
========================================================

- Shiny Web Application
- view data from the iris dataset
- enter four values (Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) to predict the Iris Species

Prediction Algorithm
========================================================

- individual models: k-Nearest Neighbours (knn), Support Vector Machine (svmRadial), Generalised Boosted Regression Model (gbm)
- combined Random Forest (rf) model using results of individual models


```
           setosa versicolor virginica class.error
setosa         10          0         0           0
versicolor      0         10         0           0
virginica       0          0        10           0
```

Server Calculation
========================================================

- 80% data in training, 20% data in validation
- train knn, svm, and gbm models, predict based on validation data, and combine predictions and actual classification into data frame
- train rf model based on data in data frame
- all models saved in app folder and loaded in server
- after loading models in server, predict based on inputs

Final Thoughts
========================================================

- documentation provided under "User Guide" tab to allow user to refer to it as needed
- stacked model used to get most accurate prediction
- user can verify prediction accuracy by choosing inputs from dataset provided
