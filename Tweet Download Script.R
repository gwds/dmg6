JETBLUE<-searchTwitter("@JETBLUE", n=10000, since='2016-09-15')
JETBLUE<-twListToDF(JETBLUE)

# run a function to create automated process to download large files
