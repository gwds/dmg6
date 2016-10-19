#sourcing tools
library(twitteR) #read from twitter streaming api
library(jsonlite) # read from json
library(readr)    # read files

#dataframe tools
library(dplyr) 
library(plyr) 
library(dplyr)    # data manipulation
library(stringr)  # text manipulation

#visualization tools
library(Amelia) #data explore
library(ggplot2)  
library(ggthemes) 
library(wordcloud)

#semantic analysis tools
library(tm) #get corpus
library(SnowballC) # stemming 
library(NLP) #root 

#machine learning tools
library(caret) #K folds cross validation
library(MASS) # stepAIC
library(e1071) #NaiveBayes
library(leaps) #model selection
library(bestglm)#model selection 
library(boot) # cv.glm()


clean_text <- function(text){
  #clean URLs
  temp <- gsub('((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?','URL_LINK_TWEETS',text) 
  #clean white space within in punctuation to seperate words cleverly
  temp <- gsub('[. +]|[ +.]','.',temp)
  temp <- gsub('[, +]|[ +,]',',',temp)
  temp <- gsub('[.]','. ',temp)
  temp <- gsub('[,]',', ',temp)
  temp <- gsub('. . . ','... ',temp)
  return(temp) 
}

clean_location <- function(tweets){
  lat_temp <- character()
  lng_temp <- character()
  for(i in 1:nrow(tweets)){
    if(!is.na(tweets$tweet_coord[i])){
      temp <- strsplit(tweets$tweet_coord[i],',')[[1]]
      lat_temp <- c(lat_temp,temp[1])
      lng_temp <- c(lng_temp,temp[2])
    }
    else {
      lat_temp <- c(lat_temp,NA)
      lng_temp <- c(lng_temp,NA)
    }
    
  }
  lat_temp <- gsub('\\[|\\]','',lat_temp)
  lng_temp <- gsub('\\[|\\]','',lng_temp)
  tweets$lat <- lat_temp
  tweets$lng <- lng_temp
  tweets$tweet_coord <- NULL
  return(tweets)
}


add_feature <-function(tweets){
  #add tweets length to the data
  # Create a variable holding the number of `@` characters in each tweet
  tweets$at_count <- sapply(tweets$text, function(x) str_count(x, '@'))
  maxAt <- max(tweets$at_count)
  
  # Collapse number of 'ats'that are 
  tweets$at_countD[tweets$at_count == 1] <- '1'
  tweets$at_countD[tweets$at_count == 2] <- '2'
  tweets$at_countD[tweets$at_count %in% c(3:maxAt)] <- '3+'
  
  # Change to a factor variable
  tweets$at_countD <- factor(tweets$at_countD)
  
  # Store the length of each tweet
  tweets$text_length <- sapply(tweets$text, function(x) nchar(x))
  return(tweets)
}

get_tt_data <- function(tweets){
  dt <- sort(sample(nrow(tweets), nrow(tweets)*.7))
  train<-cfix_tweets[dt,]
  test<-cfix_tweets[-dt,]
  output <- list(train,test)
  names(output)<- c('train','test')
  return(output)
  
}

get_formula <- function(Y,X,DATA){
  Y_names <- names(DATA)[Y]
  X_names <- names(DATA)[X]
  Y_X <- as.formula(paste(paste(Y_names,collapse = '+'),'~',paste(X_names,collapse = '+')))  
  return(Y_X)
}

