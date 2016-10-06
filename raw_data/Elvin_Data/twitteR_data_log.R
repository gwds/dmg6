###  Below is log records for each batch downloaded from Twitter API ###


# tw0 Batch
tw0 <- searchTwitter("@JetBlue",
                    n=3000,
                    since = "2016-09-30",
                    until = "2016-10-01",
                    resultType = "recent",
                    retryOnRateLimit = 1000)
tw0_df <- twListToDF(tw0)
class(tw0_df$created)
range(tw0_df$created)
# tw0: "2016-09-30 00:00:02 UTC" "2016-09-30 23:56:09 UTC"

# tw Batch
tw <- searchTwitter("@JetBlue",
                    n=3000,
                    since = "2016-09-01",
                    until = "2016-09-30",
                    resultType = "recent",
                    retryOnRateLimit = 1000)

tw_df <- twListToDF(tw)

class(tw_df$created)
range(tw_df$created)
# tw: "2016-09-26 02:10:47 UTC" "2016-09-29 23:58:53 UTC"

#tw1 Batch
tw1 <- searchTwitter("@JetBlue",
                    n=1000,
                    since = "2016-10-01",
                    until = "2016-10-02",
                    resultType = "recent",
                    retryOnRateLimit = 1000)

tw1_df <- twListToDF(tw1)

class(tw1_df$created)
range(tw1_df$created)
# tw1: "2016-10-01 00:00:40 UTC" "2016-10-01 23:59:32 UTC"

# tw2 Batch
tw2 <- searchTwitter("@JetBlue",
                     n=100000,
                     since = "2016-10-02",
                     until = "2016-10-05",
                     resultType = "recent",
                     retryOnRateLimit = 1000)

tw2_df <- twListToDF(tw2)

class(tw2_df$created)
range(tw2_df$created)
# "2016-10-02 00:00:19 UTC" "2016-10-04 23:59:45 UTC"


