### Model based on Naive Bayes and SVM Using WeightBin :

set.seed(123)
tweets1<-subset(Tweets_Training,Tweets_Training$airline_sentiment %in% c("positive","negative"))
tweets_train<- as.matrix(tweets1)
head(tweets_train)

indexes<-createDataPartition(tweets_train[,1],p=.7,list=FALSE)
train.data<-tweets_train[indexes,]
test.data<-tweets_train[-indexes,]
prop.table(table(tweets1[,1]))
prop.table(table(train.data[,1]))
prop.table(table(test.data[,1]))

nrow(tweets1)
nrow(train.data)
as.data.frame(train.data)
nrow(test.data)
head(train.data)

Corpus1<-Corpus(VectorSource(train.data[,2]))
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


tweets_lower<-sapply(Corpus1, function(x) tryTolower(x))
Corpus1_clean<- VCorpus(VectorSource(tweets_lower))
## Corpus1_clean<- tm_map(Corpus1_clean,content_transformer(tolower))

tweets_rm_number<- tm_map(Corpus1_clean,removeNumbers)

tweets_stop_words<-tm_map(tweets_rm_number,removeWords,stopwords())

tweets_punc_rm<-tm_map(tweets_stop_words,content_transformer(removePunctuation))

tweets_stem<-tm_map(tweets_punc_rm, stemDocument,language="english")

tweets_final<-tm_map(tweets_stem,stripWhitespace)


----------------------
  
Corpus2<-Corpus(VectorSource(test.data[,2]))
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


tweets_lower<-sapply(Corpus2, function(x) tryTolower(x))
Corpus2_clean<- VCorpus(VectorSource(tweets_lower))
#tweets_corpus_clean<- tm_map(tweets_corpus_clean,content_transformer(tolower))

tweets_rm_number<- tm_map(Corpus2_clean,removeNumbers)

tweets_stop_words<-tm_map(tweets_rm_number,removeWords,stopwords())

tweets_punc_rm<-tm_map(tweets_stop_words,content_transformer(removePunctuation))

tweets_stem<-tm_map(tweets_punc_rm, stemDocument,language="english")

tweets_final2<-tm_map(tweets_stem,stripWhitespace)

---------------------------------


Train_dtm<-DocumentTermMatrix(tweets_final,control=list(weighting=weightBin))
train_dtm_sparse_99<-removeSparseTerms(Train_dtm,0.995)
dim(train_dtm_sparse_99)
## for using for later training purposes :
train_bag_99<-findFreqTerms(train_dtm_sparse_99)
train_bag_99

##Document term matrix to a normal matrix :
  
train_dtm_sparse_99<-as.matrix(train_dtm_sparse_99)

mean_train_99<-sort(colMeans(train_dtm_sparse_99),decreasing = T)

avg_train_99<-mean(mean_train_99[1:20])

## Plotting it :)
barplot(mean_train_99[1:20],border=NA,las=3,xlab="freq terms",ylab="average binary weights",
ylim=c(0,1))

## COMBINE SENTIMENT AND DOCUEMNTS_COLUMN
alpha<-as.data.frame(train.data)
train_data_99<- data.frame(Sentiments=alpha$airline_sentiment,train_dtm_sparse_99 )
dim(train_data_99)


===================
  
Now convert this test data as well into the same format :)

Test_dtm<-DocumentTermMatrix(tweets_final2,control=list(weighting=weightBin,
    dictionary=train_bag_99))
inspect(Test_dtm[1:10,2:20])

Test_Matrix_99<-as.matrix(Test_dtm)
beta<-as.data.frame(test.data)

Test_comb_data<-data.frame(Sentiments=beta$airline_sentiment, Test_Matrix_99)
dim(Test_comb_data)
dim(train_data_99)

=================================
  
bow_svm<-ksvm(Sentiments~.,data=train_data_99)
test1_predict<-predict(bow_svm,newdata=Test_comb_data)

Conf_SVM<-confusionMatrix(test1_predict,Test_comb_data[,1],positive="positive",
dnn=c("Prediction","TRUE"))
Conf_SVM
--------------------------
  
## Naive Bayes Classifier :

bow_nb<-naiveBayes(Sentiments~.,data = train_data_99)
test2_predict<-predict(bow_nb,newdata=Test_comb_data)
Conf_NB<-confusionMatrix(test1_predict,Test_comb_data[,1],positive = "positive",
                dnn=c("Prediction","True"))
Conf_NB

---------------------------

# Model Based On : TWIDF : LATE AT NIGHT :) and Also look out for the file,
#  which is being used for loading purposes :
  
  
  

  
  