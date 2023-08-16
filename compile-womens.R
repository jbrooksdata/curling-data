library(jsonlite)
library(tidyverse)
library(rvest)

# scrape dates from history; same format as api url
url = 'https://doubletakeout.com/history'
page = read_html(url)
dates = page %>% html_nodes("td:nth-child(2)") %>% html_text()

# blank dataframe for binding
rankings <- data.frame()

for(i in dates){
  
  url <- paste0("https://doubletakeout.com/api.php?t=women&d=",i)
  raw_json <- fromJSON(url)
  data <- raw_json$Player
  
  bind_data <- bind_cols(i,data)
  
  rankings <- bind_rows(rankings, bind_data)
}

colnames(rankings)[1] <- 'Date'

write_rds(rankings,'womens-rankings.rds')
