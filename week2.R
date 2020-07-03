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

WPL=sapply(list(blogs,news,twitter),function(x) summary(stri_count_words(x))[c('Min.','Mean','Max.')])
rownames(WPL)=c('WPL_Min','WPL_Mean','WPL_Max')
stats=data.frame(
  Dataset=c("blogs","news","twitter"),      
  t(rbind(
    sapply(list(blogs,news,twitter),stri_stats_general)[c('Lines','Chars'),],
    Words=sapply(list(blogs,news,twitter),stri_stats_latex)['Words',],
    WPL)
  ))
head(stats)

blogs <- iconv(blogs, "latin1", "ASCII", sub="")
news <- iconv(news, "latin1", "ASCII", sub="")
twitter <- iconv(twitter, "latin1", "ASCII", sub="")

set.seed(519)
sample_data <- c(sample(blogs, length(blogs) * 0.01),
                 sample(news, length(news) * 0.01),
                 sample(twitter, length(twitter) * 0.01))



corpus <- VCorpus(VectorSource(sample_data))
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, PlainTextDocument)



uni_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
bi_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
tri_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))

uni_matrix <- TermDocumentMatrix(corpus, control = list(tokenize = uni_tokenizer))
bi_matrix <- TermDocumentMatrix(corpus, control = list(tokenize = bi_tokenizer))
tri_matrix <- TermDocumentMatrix(corpus, control = list(tokenize = tri_tokenizer))



uni_corpus <- findFreqTerms(uni_matrix,lowfreq = 50)
bi_corpus <- findFreqTerms(bi_matrix,lowfreq=50)
tri_corpus <- findFreqTerms(tri_matrix,lowfreq=50)

uni_corpus_freq <- rowSums(as.matrix(uni_matrix[uni_corpus,]))
uni_corpus_freq <- data.frame(word=names(uni_corpus_freq), frequency=uni_corpus_freq)
bi_corpus_freq <- rowSums(as.matrix(bi_matrix[bi_corpus,]))
bi_corpus_freq <- data.frame(word=names(bi_corpus_freq), frequency=bi_corpus_freq)
tri_corpus_freq <- rowSums(as.matrix(tri_matrix[tri_corpus,]))
tri_corpus_freq <- data.frame(word=names(tri_corpus_freq), frequency=tri_corpus_freq)
head(tri_corpus_freq)
head(bi_corpus_freq)
head(uni_corpus_freq)