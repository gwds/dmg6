setwd("C:\\Users\\oycy\\Desktop\\twitteR Data Collection")

library(dplyr)

tweet_df <- read.csv("tweet_database.csv", stringsAsFactors = FALSE)
tweet_df <- tweet_df %>%
  mutate(favoriteCount = as.numeric(favoriteCount),
         created = as.POSIXct(strptime(created, "%Y-%m-%d %T")),
         replyToSID = as.character(replyToSID),
         id = as.character(id),
         replyToUID = as.character(replyToUID),
         retweetCount = as.numeric(retweetCount),
         longitude = as.character(longitude),
         latitude = as.character(latitude)
  )

# Get rid of reweets and duplicates
clean_tw_df <- tweet_df %>%
  filter(isRetweet == FALSE) %>%
  mutate(dups= duplicated(text)) %>%
  filter(dups == FALSE) %>%
  select(1:16)

