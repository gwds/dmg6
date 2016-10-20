library(dplyr)

standardized_loading <- function(file_location, loaded_df){
  loaded_df <- read.csv(file_location, stringsAsFactors = FALSE)
  loaded_df <- loaded_df %>%
    mutate(favoriteCount = as.numeric(favoriteCount),
           created = as.POSIXct(strptime(created, "%Y-%m-%d %T"), tz="GMT"),
           replyToSID = as.character(replyToSID),
           id = as.character(id),
           replyToUID = as.character(replyToUID),
           retweetCount = as.numeric(retweetCount),
           longitude = as.character(longitude),
           latitude = as.character(latitude)
           )
  return(loaded_df)
}

tw_df_standardization <- function(target_df){
  target_df <- target_df %>%
    mutate(favoriteCount = as.numeric(favoriteCount),
           created = as.POSIXct(strptime(created, "%Y-%m-%d %T"), tz="GMT"),
           replyToSID = as.character(replyToSID),
           id = as.character(id),
           replyToUID = as.character(replyToUID),
           retweetCount = as.numeric(retweetCount),
           longitude = as.character(longitude),
           latitude = as.character(latitude)
    )
  return(target_df)
}