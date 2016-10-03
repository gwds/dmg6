library(twitteR)

consumer_key <- "oztCMPVpT4fRRntNuuCbb2TBB"
consumer_secret <- "fiduqK47A3c3I7FpUjiYSczAC6z59urKXDZADulaR6S9C0mGwo"
access_token <- "162324889-JeCyDCXLA9chr6OdP4gCzGuqPdXLHahjQOT5h9HF"
access_secret <- "SFWkYML9kyKFp1jLNfApMsGbqth6b0E7z0K9NhVkk8G14"


setup_twitter_oauth(consumer_key = consumer_key,
                    consumer_secret = consumer_secret,
                    access_token = access_token,
                    access_secret = access_secret)

# Search Tweets
trump <- searchTwitteR("Trump", n = 3000)
# Search TwitteR results
trump <- strip_retweets(trump, strip_mt = FALSE)
# get rid of retweets
trump <- twListToDF(trump)
# store as a DataFrame
head(trump)

# Search Users
elvinouyang <- getUser("elvinouyang")
elvinouyang_fans <- lookupUsers(
                                elvinouyang$getFollowerIDs(),
                                includeNA = TRUE)
head(elvinouyang_fans)

# Converting Tweets to DF
trump_df <- twListToDF(trump)
lapply(trump_df[1,],print)

# User tweet timelines
jetblue <- userTimeline("JetBlue", n = 100)
jetblue_df <- twListToDF(jetblue)
# Use the DataFrame view to check out the available variables

print(head(jetblue_df))


