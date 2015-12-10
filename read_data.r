library(dplyr)
source("utils/remove_unit.r", encoding = "UTF-8")
source("utils/read_tag_root.r", encoding = "UTF-8")
source("utils/to_halfwidth.r", encoding = "UTF-8")

# load file ---------------------------------------------------------------

# load("data_pxmart.Rdata")
# item_names <-data_pxmart$item_name
item_names <- readLines("data/item_names.txt", encoding = "UTF-8")

length(item_names) # 977952 records
length(unique(item_names)) # 62555 unique items

tag_root_list <- read_tag_root(file="data/tag_root.tsv", encoding = "UTF-8")
# plyr::ldply(tag_root_list, data.frame, .id="tag")

key_dominant <- readLines("data/key_dominant.txt", encoding = "UTF-8")

# clear and unique --------------------------------------------------------

# item_names <- item_names[!grepl("扣抵", item_names)] # remove coupon item
item_unique <- unique(item_names)
item_unique_wo_unit <- unique(remove_unit(item_unique))
# writeLines(item_unique_wo_unit, "result/item_unique.txt")  # output for n-gram
