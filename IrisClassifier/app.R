#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
library(gbm)
library(caretEnsemble)
library(kernlab)
library(randomForest)

# Define UI for application that predicts iris species
ui <- fluidPage(

    # Application title
    titlePanel("IrisClassifier"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          textInput("sepal.length", "Enter Sepal Length:"),
          textInput("sepal.width", "Enter Sepal Width:"),
          textInput("petal.length", "Enter Petal Length:"),
          textInput("petal.width", "Enter Petal Width:"),
          actionButton("submit", "Enter")
        ),

        # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(id = "tabs",
            tabPanel("User Guide", br(), htmlOutput("text")),
            tabPanel("Iris Dataset", br(), dataTableOutput("data")),
            tabPanel("Prediction", column(11, align = "center",
                                          br(),
                                          imageOutput("image"),
                                          br(),
                                          textOutput("prediction")))
          )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, session, output) {
  
    output$text <- renderText({
      one <- "IRISCLASSIFIER USER GUIDE"
      two <- "<br>"
      three <- "IrisClassifier is a Shiny Web Application that allows the user"
      four <- "to view data from the iris dataset and enter four values"
      five <- "(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) to predict"
      six <- "the Iris Species."
      seven <- "<br>"
      eight <- "Disclaimer:"
      nine <- "  1. All fields must be filled before clicking the \"Enter\" button."
      ten <- "  2. The \"Enter\" button must be clicked to generate a prediction -"
      eleven <- "      simply pressing the \"Enter\" or \"Return\" key on the keyboard"
      twelve <- "      will not do anything."
      thirteen <- "<br>"
      fourteen <- "Users can switch between the data tab and the prediction tab to see"
      fifteen <- "the original iris dataset and the prediction computed from the inputs."
      
      HTML(paste(one, "<br>", two, three, four, five, six, "<br>", seven, eight, "<br>", nine, "<br>", ten, eleven, twelve, "<br>", thirteen, fourteen, fifteen))
      
    })
  
    output$data <- renderDataTable(iris)
    
    output$image <- renderImage({
      outfile <- "IrisSpecies.JPG"
      contentType <- "image/jpg"
      list(src = outfile, contentType = contentType)
    }, deleteFile = FALSE)

    observeEvent(input$submit, {
      output$prediction <- renderText({
        inputs <- cbind(Sepal.Length = as.numeric(input$sepal.length), 
                        Sepal.Width = as.numeric(input$sepal.width),
                        Petal.Length = as.numeric(input$petal.length),
                        Petal.Width = as.numeric(input$petal.width))
        
        knnModel <- get(load(file = "knnModel.rda"))
        svmModel <- get(load(file = "svmModel.rda"))
        gbmModel <- get(load(file = "gbmModel.rda"))
        stackedModel <- get(load(file = "stackediris.rda"))
        
        knnPred <- predict(knnModel, newdata = inputs)
        svmPred <- predict(svmModel, newdata = inputs)
        gbmPred <- predict(gbmModel, newdata = inputs)
        combPredDF <- data.frame(knnPred, svmPred, gbmPred)
        stackedPred <- predict(stackedModel, newdata = combPredDF)
        
        if(as.character(stackedPred) == "setosa") {
          output$image <- renderImage({
            outfile <- "setosa.jpg"
            contentType <- "image/jpg"
            list(src = outfile, contentType = contentType)
          }, deleteFile = FALSE)
        } else if(as.character(stackedPred) == "versicolor") {
          output$image <- renderImage({
            outfile <- "versicolor.jpg"
            contentType <- "image/jpg"
            list(src = outfile, contentType = contentType)
          }, deleteFile = FALSE)
        } else if(as.character(stackedPred) == "virginica") {
            output$image <- renderImage({
              outfile <- "virginica.jpg"
              contentType <- "image/jpg"
              list(src = outfile, contentType = contentType)
            }, deleteFile = FALSE)
        }
        
        as.character(stackedPred)
      })
      
      updateTabsetPanel(session, "tabs", "Prediction")
      
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
