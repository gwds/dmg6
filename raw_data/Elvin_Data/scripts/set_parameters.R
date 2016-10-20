since_date <- readline(prompt = "What is the 'since' date for your Twitter query? (yyyy-mm-dd)")
since_date <- as.Date(since_date, "%Y-%m-%d")
if (since_date < Sys.Date() - 9){since_date <- Sys.Date() - 9}
# Define since date

until_date <- readline(prompt = "What is the 'until' date for your Twitter query? (yyyy-mm-dd)")
until_date <- as.Date(until_date, "%Y-%m-%d")
if (until_date < since_date) {
  until_date <- since_date + 1} else if (until_date > Sys.Date()){
    until_date <- Sys.Date() - 1
  }
# Todo: add a loop to repeat the same question if user input is not in the correct format

since_date <- as.character(since_date)
until_date <- as.character(until_date)

dataframe_name <- sub(" ", "", paste("tw_df_",format(Sys.Date(),"%m_%d")))

archive_file_path <- gsub(" ", "", 
                         paste("archive\\tweet_database_", as.character(format(Sys.time(),"%m_%d_%H_%M_%S")),
                               ".csv"))

full_tweet_path <- "tweet_database.csv"

download_log_path <- "download_log.csv"
