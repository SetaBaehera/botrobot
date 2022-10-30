library(rvest)
library(rtweet)
library(urlshorteneR)
library(RPostgreSQL)

## Membuat Twitter token
twitter_token <- rtweet::rtweet_bot(
  api_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  api_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv,
                 dbname = Sys.getenv("ELEPHANT_SQL_DBNAME"), 
                 host = Sys.getenv("ELEPHANT_SQL_HOST"),
                 port = 5432,
                 user = Sys.getenv("ELEPHANT_SQL_USER"),
                 password = Sys.getenv("ELEPHANT_SQL_PASSWORD")
)
query <- '
CREATE TABLE IF NOT EXISTS jagatplay (
  Title character(),
  Caption character,
  Link character
)
'
data <- dbGetQuery(con, query)

query2 <- 'SELECT * FROM jagatplay ORDER BY "No" ASC;'

data <- dbGetQuery(con, query2)
baris <- nrow(data)

## Mengecek, menyimpan dan memposting artikel baru yang ditambahkan oleh website https://jagatplay.com/ pada tanggal hari ini.
url <- 'https://jagatplay.com/'

webpage <- read_html(url)

title <- html_nodes(webpage,'.art__content>a') %>% 
  html_text("title")
title

link <- html_nodes(webpage,'.art__content>a') %>% 
  html_attr("href")
link

caption <- html_nodes(webpage, '.art__excerpt')%>%
  html_text("div")
caption

data <- data.frame(title,caption,link)
dbWriteTable(conn = con, name = "jagatplay", value = data, append = TRUE, row.names = FALSE, overwrite=FALSE)
on.exit(dbDisconnect(con))   
  