library(twitteR)

# Batch Database Name:
tweet_df

# Write into csv file:
write.csv(tweet_df, file = "tweet_database_version_date.csv",
          eol = "\n", na = "NA", row.names = FALSE)

# Batch Record:
range(tweet_df$created)
# "2016-09-26 02:10:47 UTC" "2016-10-04 23:59:45 UTC"

# Standard Batch Query Code:#
tw_n <- searchTwitter("@JetBlue",
                      n=3000,
                      since = "start_date_inclusive",
                      until = "end_date_exclusive",
                      resultType = "recent",
                      retryOnRateLimit = 1000)
tw_n_df <- twListToDF(tw_n)
class(tw_n_df$created)
range(tw_n_df$created)

# If above all confirmed, append to the Batch Database:
tweet_df <- read.csv("tweet_database_v1_10.05.csv")
tweet_df <- cbind(tweet_df, tw_n_df)
