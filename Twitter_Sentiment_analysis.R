## Basic apporach for twitter feeds stroing and analysis :


# Install and Activate Packages

library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)

# Make the twitter dev account for your api keys and connections auth :
# I made mine , and you will receive four credentials from Twitter that allow you to connect to Twitter API with your personal account :  

api_key, api_secret, access_token, access_token_secret

# Calling the function to connect with twitter api using your auth id & Keys :

setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

# Using Search twitter function to # some event, or some particular stuff we are looking into 

Love<-searchTwitter("#Election2016", n=1000,since = "2016-09-01")
tweets.dft <- twListToDF(Love)
colnames(tweets.df)
head(tweets.df)
write.table(tweets.df,"Analysis_Election.csv")

# Trying to Fetch result for last night Predential debate and find out who 
# has won the poll 
## Now the Target is to capture maximum tweets ??
## Start using algo to the corpus and finding the ways to get the best out of all 
## given tweets.
tweets.df$text

MyCorpus <- tm_map(tweetcorpus,
                   content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')),
                   mc.cores=1)
library("tm")
tweetscorpus<- VCorpus(VectorSource(tweets.df$text))


tweetcorpus<-tm_map(tweetcorpus,contenttransformer(tolower))
tweetcorpus<-tm_map(tweetcorpus,removePunctuation)
tweetcorpus<-tm_map(tweetcorpus,removeNumbers,lazy=TRUE)
tweetcorpus<-tm_map(tweetcorpus,function(x)removeWords(x,stopwords()))
tweetcorpus<-tm_map(tweetcorpus,PlainTextDocument)

## Trying a wordcloud 
library("wordcloud")
wordcloud(tweetcorpus,min.freq=4,scale=c(5,1),random.color=F,max.word=45,random.order=F)
### creating a text document matrix

tweettdm<-TermDocumentMatrix(tweetcorpus)



