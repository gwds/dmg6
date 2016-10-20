library(twitteR)

download_tw_df <- function(since_date, until_date, term = "@JetBlue", number = 3000){
  df <- searchTwitter(term,
                      n=number,
                      since = since_date,
                      until = until_date,
                      resultType = "recent",
                      retryOnRateLimit = 1000)
  df <- twListToDF(df)
  return(df)
}

