library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv,
                 dbname = Sys.getenv("ELEPHANT_SQL_DBNAME"), 
                 host = Sys.getenv("ELEPHANT_SQL_HOST"),
                 port = 5432,
                 user = Sys.getenv("ELEPHANT_SQL_USER"),
                 password = Sys.getenv("ELEPHANT_SQL_PASSWORD")
)

query2 <- '
SELECT * FROM "public"."jagatplay"
'

data <- dbGetQuery(con, query2)

## 1st Hashtag
hashtag <- c("Games","OnlineGames", "MMORPG","PlayStation","XBox", "Nintendo", "PS5", "PS4", "opensource", "PCGaming","LaptopGaming","Racing", "Steam")

samp_word <- sample(hashtag, 1)

library(dplyr)

## Status Message
status_details <- paste0(
  Sys.Date(),
  ":",
  "\n",
  data$link[6],
  "\n",
  "#",samp_word)


# Publish to Twitter
library(rtweet)

## Create Twitter token
jagatplay_token <- rtweet::rtweet_bot(
  api_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  api_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)

## Provide alt-text description
alt_text <- paste0(
  "Contoh Twitter Bot tentang Dunia Games"
)


## Post the image to Twitter
rtweet::post_tweet(
  status = status_details,
  media_alt_text = alt_text,
  token = jagatplay_token
)

on.exit(dbDisconnect(con))
