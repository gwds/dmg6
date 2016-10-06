library(dplyr)

download_summary <- function(tw_df){
  summary <- tw_df %>%
    summarise(
      batch_time = Sys.time(),
      updated_to = max(created),
      ever_since = min(created),
      num_tweets = length(text),
      num_retweets = sum(isRetweet),
      num_dups = sum(duplicated(text))
    )
  return(summary)
}


log_standardized_loading <- function(file_location, df = NULL){
  df <- read.csv(file_location, stringsAsFactors = FALSE)
  df <- df %>%
    mutate(batch_time = as.POSIXct(strptime(batch_time, "%Y-%m-%d %T"), tz="EDT"),
           updated_to = as.POSIXct(strptime(updated_to, "%Y-%m-%d %T"), tz="GMT"),
           ever_since = as.POSIXct(strptime(ever_since, "%Y-%m-%d %T"), tz="GMT"))
  return(df)}
