#Data Structure
str(tweets.df)
#Load tm Package
library(tm)
#######################CREATE A CORPUS OF TEXT#########################################
tweets_corpus<- VCorpus(VectorSource(tweets.df$text))
#Print Number of Documents 
print(tweets_corpus)
#TO GET SPECIFIC MESSAGE SUMMARY
inspect(tweets_corpus[1:2])
#TO READ SPECIFIC MESSAGE TEXT
as.character(tweets_corpus[[3]])
#######################CLEANING THE CORPUS############################################
#TO AVOID TOLOWER ERROR WHEN FINDING AN EMOJI IN TEXT (NON GRAPHICAL TEXT) I FOUND THIS FUNCTION
##USED TO SKIP ERROR AND CONTINUE TOLOWER
tryTolower = function(x)
{
  # create missing value
  # this is where the returned value will be
  y = NA
  # tryCatch error
  try_error = tryCatch(tolower(x), error = function(e) e)
  # if not an error
  if (!inherits(try_error, "error"))
    y = tolower(x)
  return(y)
}
#NOW USE THE TOLOWER WITH THE TRYLOWER FUNCTION TO LOWERCASE THE CORPUS TEXT
tweets_corpus_clean<-sapply(tweets_corpus, function(x) tryTolower(x))
#CHANGE TYPE TO VCORPUS
tweets_corpus_clean<- VCorpus(VectorSource(tweets_corpus_clean))
tweets_corpus_clean<- tm_map(tweets_corpus_clean,content_transformer(tolower))
str(tweets_corpus_clean)
#TO CHECK LOWERCASE IS DONE
as.character(tweets_corpus[[12]])
as.character(tweets_corpus_clean[[12]])
#REMOVE NUMBERS FROM CORPUS TEXT
tweets_corpus_clean<- tm_map(tweets_corpus_clean,removeNumbers)
#CHECK NUMBERS ARE REMOVED
as.character(tweets_corpus[[11]])
as.character(tweets_corpus_clean[[11]])
#REMOVE STOP WORDS FROM CORPUS TEXT
tweets_corpus_clean<-tm_map(tweets_corpus_clean,removeWords,stopwords())
#CHECK STOP WORDS ARE REMOVED
as.character(tweets_corpus[[11]])
as.character(tweets_corpus_clean[[11]])
#CREATE A REPLACE PUNCYUATION FUNCTION (REPLACE ... WITH BLANKS RATEHR THAN REMOVE)
replacePunctuation<- function(x){
  gsub("[[:punct:]]+"," ",x)  
}
#TEST FUNCTION
replacePunctuation("Give me a .. break")
#REMOVE PUNCTUATION FROM CORPUS TEXT 
tweets_corpus_clean<-tm_map(tweets_corpus_clean,content_transformer(replacePunctuation))
#CHECK PUNCTUATIONS ARE REPLACED BY BLANKS
as.character(tweets_corpus[[11]])
as.character(tweets_corpus_clean[[11]])
#STEMMING OF THE WORDS IN THE CORPUS TEXT
library(SnowballC)
tweets_corpus_clean<-tm_map(tweets_corpus_clean, stemDocument,language="english")
#CHECK STEMMING OF WORDS
as.character(tweets_corpus[[29]])
as.character(tweets_corpus_clean[[29]])
#STRIP WHITE SPACE FROM THE CORPUS TEXT
tweets_corpus_clean<-tm_map(tweets_corpus_clean,stripWhitespace)
#CHECK WHITE SPACE IS REMOVED
as.character(tweets_corpus[[6]])
as.character(tweets_corpus_clean[[6]])
#########################TOKENIZATION OF TEXT DOC INTO WORDS################################
#CREATE A DOCUMENT TERM MATRIX
tweets_dtm<-DocumentTermMatrix(tweets_corpus_clean)
########################VISUALIZE TEXT DATA###############################################
#LOAD THE WORDCLOUD PACKAGE
library(wordcloud)
#CHECK THE MOST FREQUENT WORDS
wordcloud(tweets_corpus_clean,min.freq = 50,random.order = FALSE,scale=c(10, .8),colors=brewer.pal(6, "Dark2"))
#######################REDUCE THE DATA (REMOVE WORDS OF FEW FREQUENCY)####################
#GET WORDS WITH THE LEAST FREQUENCY OF 5 TIMES
tweets_freq_words<-findFreqTerms(tweets_dtm,5)
#REDUCE THE DTM SIZE WITH THE MOST IMPORTANT FREQUENT WORDS
tweets_dtm_reduced<-tweets_dtm[,tweets_freq_words]
#******************************************************************************************#
#******************************************************************************************#  
#################################TEST TIDYTEXT PACKAGE SENTIMENT ANALYSIS###########################
#LOAD tidytext package
library(tidytext)
library(dplyr)

ap_td <- tidy(tweets_dtm_reduced)

bing <- sentiments %>%
  filter(lexicon == "nrc") %>%
  select(word, sentiment)

ap_sentiments <- ap_td %>%
  inner_join(bing, by = c(term = "word"))

ap_sentiments

#NOTICE THAT DOCUMENTS NUMBER ARE NOW 2883 BECAUSE OF ONLY MATCHED WORDS DOCUMENTS TO THE LEXICON ARE TAKEN INTO CONSIDERATION

#**************************AGGREGATE SENTIMENTS FOR EACH TWEET**************

#Check Data Structure of ap_sentiments
str(ap_sentiments)
#Change Sentiments into Character
ap_sentiments$sentiment <- as.character(ap_sentiments$sentiment)
#Seperate Sentiments including emotions Variables into Columns and count 1 for each 
ap_sentiments$positive <- ifelse(ap_sentiments$sentiment == "positive",as.numeric(1),0)
ap_sentiments$negative <- ifelse(ap_sentiments$sentiment == "negative",as.numeric(1),0)
ap_sentiments$trust <- ifelse(ap_sentiments$sentiment == "trust",as.numeric(1),0)
ap_sentiments$anger <- ifelse(ap_sentiments$sentiment == "anger",as.numeric(1),0)
ap_sentiments$anticipation <- ifelse(ap_sentiments$sentiment == "anticipation",as.numeric(1),0)
ap_sentiments$disgust <- ifelse(ap_sentiments$sentiment == "disgust",as.numeric(1),0)
ap_sentiments$fear <- ifelse(ap_sentiments$sentiment == "fear",as.numeric(1),0)
ap_sentiments$joy <- ifelse(ap_sentiments$sentiment == "joy",as.numeric(1),0)
ap_sentiments$sadness <- ifelse(ap_sentiments$sentiment == "sadness",as.numeric(1),0)
ap_sentiments$surprise <- ifelse(ap_sentiments$sentiment == "surprise",as.numeric(1),0)
#Check head of ap_sentiments
head(ap_sentiments,30)
#Aggregate sum of sentiment and emotion for each document
library(dplyr)
aggr_sentiments<-ap_sentiments%>%
  select(document,positive,negative,trust,anger,anticipation,disgust,fear,joy,sadness,surprise)%>%
  group_by(document)%>%
  summarise(positive=sum(positive),negative=sum(negative),trust=sum(trust),anger=sum(anger),
            anticipation=sum(anticipation),disgust=sum(disgust),fear=sum(fear),joy=sum(joy),
            sadness=sum(sadness),surprise=sum(surprise),positive_negative_total=positive+negative,emotions_total=sum(trust+anger+anticipation+disgust+fear+joy+sadness+surprise))
#Aggreagte Percentage of each tweet
percentage_sentiments<-aggr_sentiments%>%
  group_by(document)%>%
  summarise(positive=(positive/(positive_negative_total)*100),negative=(negative/(positive_negative_total)*100),
            trust=((trust/emotions_total)*100),
            anger=((anger/emotions_total)*100),
            anticipation=((anticipation/emotions_total)*100),
            disgust=((disgust/emotions_total)*100),
            fear=((fear/emotions_total)*100),
            joy=((joy/emotions_total)*100),
            sadness=((sadness/emotions_total)*100),
            surprise=((surprise/emotions_total)*100))
#Check tail of aggr_sentiments
tail(percentage_sentiments,50)
#Replace NaN values with 0
percentage_sentiments[is.na(percentage_sentiments)]<-0
#Example of Percentage_sentiments
#Lets Take tweet having different words sentiments, tweet 988
#This shows the percentage distribuition of POSITIVE - NEGATIVE     and  DISTRIBUTION OF EMOTIONS 
subset(percentage_sentiments,percentage_sentiments$document==988)
subset(percentage_sentiments,percentage_sentiments$document==223)
#The #988 and #223 tweet text
as.character(tweets_corpus[[988]])
as.character(tweets_corpus[[223]])