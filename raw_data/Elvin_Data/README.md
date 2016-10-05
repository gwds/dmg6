Just tested the Twitter API, and I have come to the following findings:
1. You can generally only run *one query every 15 minutes*, either you fit the limit or not. So be sure to store whatever received for later use.
2.  For the "@JetBlue" search string, you will receive 600-1000 tweets for each day. Considering that the limit for each query appears to be around 2500, it is safe to query for *3-4 day's worth of tweet* each time
3. More details about *since* and *until* in searchTwitter function:
  "since" is inclusive, meaning the tweets will start from the date specified by "since"
  "until" is exclusive, meaning the tweets will *stop* right before the date specified by "until"
4. Use resultType = "recent" argument in searchTwitter function:
  This will allow you to receive tweets sorted by the most recent date. If not specifying this argument, the result will be "Mixed" with both "popular" and "recent" tweets. We don't want "popular" for our tweet database because we want to include ALL TWEETS
5. *Backward search limitation*: The API seems to fail to fetch information more than 8 days ago! I am not sure about this; please try out day by day to see if you also cannot find tweets more than 8 days old!
