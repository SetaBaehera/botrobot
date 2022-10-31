library(RPostgreSQL)

query <- '
CREATE TABLE IF NOT EXISTS jagatplay (
  Title character(200),
  Caption character(200),
  Link character(200)
)
'

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv,
                 dbname = Sys.getenv("ELEPHANT_SQL_DBNAME"), 
                 host = Sys.getenv("ELEPHANT_SQL_HOST"),
                 port = 5432,
                 user = Sys.getenv("ELEPHANT_SQL_USER"),
                 password = Sys.getenv("ELEPHANT_SQL_PASSWORD")
)

# Membuat Tabel untuk Pertama Kalinya
data <- dbGetQuery(con, query)

# Memanggil Tabel, untuk membuat Primary Key nya berurutan.

query2 <- '
SELECT * FROM jagatplay
'

data <- dbGetQuery(con, query2)
baris <- nrow(data)

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
