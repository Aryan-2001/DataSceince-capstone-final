## WEEK 3


Sys.setenv(JAVA_HOME="C:/Program Files (x86)/Java/jre1.8.0_91/")
library(RWeka)
library(dplyr)
library(stringi)
library(tm)
library(RWeka)
library(ggplot2)


blogs <- readLines("final/en_US/en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
news <- readLines("final/en_US/en_US.news.txt", encoding = "UTF-8", skipNul = TRUE)
twitter <- readLines("final/en_US/en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE)
all_lines <- c(blogs,news,twitter)

## making predicting functions 

## makes corpus of the line containing the string
fun1 <- function(x){
  y <- grep(pattern = x,all_lines,ignore.case = FALSE)
  corpus <- VCorpus(VectorSource(all_lines[y]))
  corpus <- tm_map(corpus, tolower)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, PlainTextDocument)
  corpus
}

## takes string and corpus to see the best solution from quadrigram test
fun2 <- function(a,b){
  quadri_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
  tri_matrix <- TermDocumentMatrix(b, control = list(tokenize = quadri_tokenizer))
  tri_corpus <- findFreqTerms(tri_matrix)
  tri_corpus_freq <- rowSums(as.matrix(tri_matrix[tri_corpus,]))
  tri_corpus_freq <- data.frame(word=names(tri_corpus_freq), frequency=tri_corpus_freq)
  words <-  tri_corpus_freq$word
  g <- paste("",a,sep = "^")
  needed_rows <- grep(g,words)
  
  df <- tri_corpus_freq[needed_rows,]
  df <- df[order(-df$frequency),]
  df
}

#######################################################################################################


## Question one
c1 <- fun1("a case of")
ans1 <- fun2("a case of",c1)
head(ans1)

## answer is beer since the is nor exactly a word



## Question 2
c2 <- fun1("would mean the")
ans2 <- fun2("would mean the",c2)
head(ans2)

## answer is the world



## Question 3
c3 <- fun1("make me the")
ans3 <- fun2("make me the",c3)
head(ans3)

## happiest is the answer 




## Question 5
c5 <- fun1("date at the")
ans5 <- fun2("date at the",c5)
ans5$word
## grocery then beach


## Question6
c6 <- fun1("be on my")
ans6 <- fun2("be on my",c6)
head(ans6)
## answer - way


## Question 7
c7 <- fun1("in quite some")
ans7 <- fun2("in quite some",c7)
head(ans7)
## time is answer



## Question 8
c8 <- fun1("with his little")
ans8 <- fun2("with his little",c8)
head(ans8)
## no answer match
length(grep("finger",ans8$word))
length(grep("eye",ans8$word))
length(grep("ear",ans8$word))
length(grep("toe",ans8$word))
## so by elimination finger is the answer



##Question 9
c9 <- fun1("during the worse")
ans9 <- fun2(" faith during worse",c9)
head(ans9)## No entry found
c9 <- fun1("during the bad")
ans9 <- fun2(" faith during bad",c9)
head(ans9)## No entry found
c9 <- fun1("during the hard")
ans9 <- fun2(" faith during hard",c9)
head(ans9)## entries are found
c9 <- fun1("during the sad")
ans9 <- fun2(" faith during sad",c9)
head(ans9)##
## answer is hard


#Question 10
c10 <- fun1("must be asleep")
ans10 <- fun2("must be asleep",c10)
head(ans10)##only once
c10 <- fun1("must be insane")
ans10 <- fun2("must be insane",c10)
head(ans10)##twice
c10 <- fun1("must be insensitive")
ans10 <- fun2("must be insensitive",c10)
head(ans10)## No example
c10 <- fun1("must be callous")
ans10 <- fun2("must be callous",c10)
head(ans10)## No example
## hence answer is insane
