#### Load packages ####
library(readr)    # read files
library(ggplot2)  # visualization
library(ggthemes) # visualization
library(dplyr)    # data manipulation
library(stringr)  # text manipulation
library(Amelia)
library(tm)
library(leaps)
library(bestglm)
library(caret)
library(boot)
library(MASS)
library(e1071)
source(file('airline_utilities.R'))

####get the data and clean it####
tweets <- read.csv('Tweets.csv',header=T)

tweets$tweet_created <- as.POSIXct(tweets$tweet_created)
tweets[,sapply(tweets,is.factor)] <- sapply(tweets[,sapply(tweets,is.factor)],as.character)

#make all factor column character class
tweets$text <- gsub('((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?','URL_LINK_TWEETS',tweets$text)
tweets <- clean_location(tweets)
tweets <- add_feature(tweets)

#get rid of NEUTRAL sentiment data
tweets <- tweets[tweets$airline_sentiment !='neutral',]

#BUILD MODEL1, without information for loication & timezone
##get rid of the broken column
missmap(tweets,rank.order = F)
broken_colnum <- c(4,5,7,9,13,14,15,16)
missmap(tweets[-broken_colnum])
cfix_tweets <- tweets[-broken_colnum]
cfix_tweets[,sapply(cfix_tweets,is.character)] <- as.data.frame(lapply(cfix_tweets[,sapply(cfix_tweets,is.character)],as.factor))

#get train/test dataset
train <- get_tt_data(cfix_tweets)[['train']]
test <- get_tt_data(cfix_tweets)[['test']]

#### LINEAR MODEL TEST ####
FORMULA <- get_formula(2,c(4,6,8,9,10,11),cfix_tweets)
#and the prediction results is:
log_model1 <- glm(FORMULA, data=train, family=binomial)
log_pred1 <- predict(log_model1, newdata=test, type="response")
table(test$airline_sentiment, log_pred1>.5)
#with formula
#FALSE TRUE
#negative  2617  110
#positive   559  177

#find the best formula by stepAIC
model_full <- glm(FORMULA,train,family = binomial)
model_0 <- glm(airline_sentiment~1,train,family = binomial)
feature_selection <- stepAIC(model_0,scope=FORMULA,direction = 'forward')
#
BEST_FORMULA <- as.formula('airline_sentiment ~ text_length + airline + at_count + tweet_created')


#and the prediction results is:
log_model2 <- glm(BEST_FORMULA, data=train, family=binomial)
log_pred2 <- predict(log_model2, newdata=test, type="response")
table(test$airline_sentiment, log_pred2>.5)
#with_best formula
#FALSE TRUE
#negative  2617  110
#positive   556  180



#PS: another way of finding best features:
cv.glm(cfix_tweets,log_model1,K=10)$delta[1]



#PS: another way of finding best features:
cv.glm(cfix_tweets,log_model1,K=10)$delta[1]
