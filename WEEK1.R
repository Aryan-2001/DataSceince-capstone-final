
## QUIZ1


download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip","data.zip")
unzip("data.zip")

setwd("final")


## QUESTION 1
file.size("en_US/en_US.blogs.txt")/1048576
##200 MB



## Question 2
data <- readLines("en_US/en_US.twitter.txt")
##over 2 million



## Question 3
data1 <- readLines("en_US/en_US.blogs.txt")
data2 <- readLines("en_US/en_US.news.txt")
x <- as.numeric(lapply(data1,stri_length))
y <- as.numeric(lapply(data2,stri_length))
max(x)
max(y)
##Over 40 thousands in blogs datasets



## Question4
data3 <- readLines("en_US/en_US.twitter.txt")
x <- grep("love",data3)
y <- grep("hate",data3)
z <- length(x)/length(y)
## 4



# Question5
data3 <- readLines("en_US/en_US.twitter.txt")
x<- grep("biostats",data3 )
data3[x[1]]
##"i know how you feel.. i have biostats on tuesday and i have yet to study =/"



## Question6
data3 <- readLines("en_US/en_US.twitter.txt")
x <- grep("A computer once beat me at chess, but it was no match for me at kickboxing",data3)
length(x)
## 3
