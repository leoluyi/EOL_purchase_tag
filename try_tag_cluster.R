library(dplyr)
library(ggplot2)

# read data ---------------------------------------------------------------

# source("read_data.r", encoding = "UTF-8")

load("data_pxmart.Rdata")
head(data_pxmart)

# tagging all --------------------------------------------------------------

load("result/items_with_tag_all.RData")
head(items_with_tag_all)
length(items_with_tag_all)

# build matrix -------------------------------------------------------------

all_tags <- items_with_tag_all %>% unlist(., use.names = FALSE) %>% unique()

## reserve space
m <- matrix(nrow = length(items_with_tag_all), ncol = length(all_tags))



