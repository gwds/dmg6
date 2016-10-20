##Major Update: Automated Tweet Data Aggregation
**Scripts included in this file can now automatically download tweets containing "@JetBlue" in a user-defined time range, automatically update a master dataset (in csv format) and create update logs (also in csv format).**

1. To get started, open the [(sourcing) run_tweet_update.R](https://github.com/gwds/dmg6/blob/master/raw_data/Elvin_Data/(sourcing)%20run_tweet_update.R) and follow the *STEPs* specified in the document
  + Use *setwd()* to direct working directory to the root folder containing these scripts before running the program
  + Create your own Twitter API tokens and secrets at [this link](https://apps.twitter.com/) and paste your credentials into [Twitter API Set-up.R](https://github.com/gwds/dmg6/blob/master/raw_data/Elvin_Data/scripts/Twitter%20API%20Set-up.R). Save the script and the sourcing code will automatically set up the API link for you
  + When prompted by R to enter expected dates, **type entires according to the expected formats**; otherwise the system would run into error
2. R scripts containing global parameters and functions are included in the [scripts](https://github.com/gwds/dmg6/tree/master/raw_data/Elvin_Data/scripts) folder. In order to sucessfully run the program, **users need to download these files**
3. To have a quick look at the aggregated dataset sample, check out [tweet_database.csv](https://github.com/gwds/dmg6/blob/master/results_reports/Elvin%20Results/tweet_database.csv). To quickly check out the download log file, check out [download_log.csv](https://github.com/gwds/dmg6/blob/master/results_reports/Elvin%20Results/download_log.csv)
4. __**Future updates will include sourced scripts that will automatically complete data cleaning, text mining, and more.**__ 

##Findings about Twitter API
1.  __**Backward search limitation**__: The API seems to fail to fetch information more than 8 days ago! I am not sure about this; please try out day by day to see if you also cannot find tweets more than 8 days old!
2. ~~You can generally only run *one query every 15 minutes*, either you fit the limit or not. So be sure to store whatever received for later use.~~ (This point does not hold true after I figure out the "limits" come from limited backward tweet record kept by the API)
3.  For the "@JetBlue" search string, you will receive 600-1000 tweets for each day. ~~Considering that the limit for each query appears to be around 2500, it is safe to query for *3-4 day's worth of tweet* each time~~
4. **More details about *since* and *until* in searchTwitter function:**
  + "since" is inclusive, meaning the tweets will start from the date specified by "since"
  + "until" is exclusive, meaning the tweets will *stop* right before the date specified by "until"
5. Use *resultType = "recent"* argument in searchTwitter function:
  +This will allow you to receive tweets sorted by the most recent date. If not specifying this argument, the result will be "Mixed" with both "popular" and "recent" tweets. We don't want "popular" for our tweet database because we want to include ALL TWEETS 
