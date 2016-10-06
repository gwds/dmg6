# STEP ONE: SET UP STAGE
setwd("C:\\Users\\oycy\\Desktop\\twitteR Data Collection")

source("scripts\\Twitter API Set-up.R")
# Set up Twitter API

source("scripts\\set_parameters.R")
# Define Tweet search parameters
# Defined parameters:
# since_date, until_date, dataframe_name, archive_file_path, full_tweet_path



# STEP TWO: Download and load new queries
source("scripts\\function_download_tw_df.R")
# Load function download_tw_df()

assign(dataframe_name,download_tw_df(since_date, until_date))
# Download tweet from specified date range and store with the dataframe_name



# STEP THREE: Append new entries to existing dataframe
source("scripts\\function_standardized_loading.R")
# Load two functions: 
# standardized_loading() and tw_df_standardization()

tweet_df <- standardized_loading("tweet_database.csv", tweet_df)
# Load the prestored dataset and format with standard formatting

tweet_df <- rbind(tweet_df, get(dataframe_name))
# Append the newly downloaded tweet data to the existing dataframe

file.copy(from = full_tweet_path, to = archive_file_path)
# Copy the existing tweet_df to archive

write.csv(tweet_df, file = full_tweet_path,
          eol = "\n", na = "NA", row.names = FALSE)
# Overwrite with the updated tweet_df



# STEP FOUR: Update the file download log for future reference
source("scripts\\function_download_log.R")

download_update <- download_summary(get(dataframe_name))
# Create log summary for newly downloaded data

download_log <- log_standardized_loading(download_log_path)
download_log <- rbind(download_log, download_update)
# Append the new log to the log summary table

write.csv(download_log, file = download_log_path,
          eol = "\n", na = "NA", row.names = FALSE)
# Overwrite the log summary table