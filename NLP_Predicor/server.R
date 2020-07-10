#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
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


string_manupulate <- function(x,y){
  str1 <- strsplit(x,split = " ")[[1]] 
  if(y==4){
    str2 <- c(str1[length(str1)-2], str1[length(str1)-1] ,str1[length(str1)])
    z<- c(1,2,3)
  }else if(y==3){
    str2 <- c(str1[length(str1)-1],str1[length(str1)])
    z<- c(1,2)
  }else if(y==2){
    str2 <- c(str1[length(str1)])
    z<- c(1)
      }
  
  for(i in z){
    if(i==1){
      str3 <- paste("",str2[i],sep = "")
    }else{
      str3 <- paste(str3,str2[i],sep=" ")
    }
  }
  print("found input string....")
  return(str3)
}



fun1 <- function(x,all_lines){
 
  y <- grep(pattern = x,all_lines,ignore.case = FALSE)
  corpus <- VCorpus(VectorSource(all_lines[y]))
  corpus <- tm_map(corpus, tolower)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, PlainTextDocument)
  print("making corpus.....")
  corpus
}

fun2 <- function(a,b,n){
  print("finding answer.....")
  quadri_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = n, max = n))
  tri_matrix <- TermDocumentMatrix(b, control = list(tokenize = quadri_tokenizer))
  tri_corpus <- findFreqTerms(tri_matrix)
  g <- paste("",a,sep = "^")
  needed_rows <- grep(g,tri_corpus)
  tri_corpus <- tri_corpus[needed_rows]
  tri_corpus_freq <- rowSums(as.matrix(tri_matrix[tri_corpus,]))
  tri_corpus_freq <- data.frame(word=names(tri_corpus_freq), frequency=tri_corpus_freq)
  df<- tri_corpus_freq
  df <- df[order(-df$frequency),]
  df$word
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
   output$output1 <- renderText(input$input2)
    
   make_input_string <- reactive({
   print("finding input string....")
   string <-string_manupulate(input$input,input$input2)
   string
   })
   
   output$output2 <- renderText(make_input_string())
   setwd("C:/Users/Aryan/Desktop/DataSceince-capstone-final")
   blogs <- readLines("final/en_US/en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
   news <- readLines("final/en_US/en_US.news.txt", encoding = "UTF-8", skipNul = TRUE, warn = FALSE)
   twitter <- readLines("final/en_US/en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE)
   print("reading files.....")
   all_lines <- c(blogs,news,twitter)
   
   predict_line <- reactive({
     string <- make_input_string()
     c1 <- fun1(string,all_lines)
     ans <- fun2(string,c1,input$input2)
     print("pridicting....")
     t<-ans[1:input$input3]
     std<-""
     for (i in t){
       std <- paste(std,i,sep="   ||    ")
     } 
     print("finish....")
     std
     
   })
  
  output$Output3 <- renderText(predict_line())
  print("processing start....")
  
   })