#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(RWeka)
library(dplyr)
library(stringi)
library(tm)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Prediction and NLP"),

    
    sidebarLayout(
        sidebarPanel(
            
            # test input for predicting as in put for n-gram model
            textInput("input","Pls put input string here",value = "a good day to"),
            
            # which n-gram model to choose 
            sliderInput("input2","choose n for the ngram model",min = 2 , max = 4 , value =3),
            
            # how many predictions you want to see
            sliderInput("input3","choose number of predictions to see", min = 5 ,max = 20,value = 10,step = 5),
        
            # submit button
            submitButton("Press when done" , icon = icon("refresh")),
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h1("N Grames model chosen is"),
            textOutput("output1"),
            h2("input gone in model is-"),
            textOutput("output2"),
            h1("predicted sentence are-"),
            textOutput("Output3")
        )
    )
))
