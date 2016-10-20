# This file includes the most commonly used functions from twitteR package
library(twitteR)

# Connect to Twitter API; need to create an app and obtain the tokens and secrets
setup_twitter_oauth(consumer_key = consumer_key,
                    consumer_secret = consumer_secret,
                    access_token = access_token,
                    access_secret = access_secret)

# Search Tweets
searchTwitteR("search_string", n = 100, 
              since = "YYYY-MM-DD", until = "YYYY-MM-DD",
              geocode = 'latitude, longitude, radius',
              resultType = 'mixed'/'recent'/'popular',
              ...)

# Returns tw_list objects

# Search User
getUser(user = "user_name" / users = user_name_vector)
# Returns details of a user

# Get user tweet timelines: everything a user posts
userTimeline("user_name", n = 100, includeRts = FALSE, excludeReplies = FALSE, ...)
# Note that the search can strip Retweets using argument "includeRts" and exclude
# replies using argument "excludeReplies")

# Save returned list object as a DataFrame
twListToDF(tw_list)
