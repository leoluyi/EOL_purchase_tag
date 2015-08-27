# packages required: data.table, dplyr, qualV, RWeka

library(dplyr)
source("utils/remove_unit.r", encoding = "UTF-8")
source("read_tag_root.r", encoding = "UTF-8")
source("utils/to_halfwidth.r", encoding = "UTF-8")
source("utils/tagging.r", encoding = "UTF-8")

# load file ---------------------------------------------------------------

item_names <- readLines("data/item_names.txt", encoding = "UTF-8")

length(item_names) # 977952 records
length(unique(item_names)) # 62555 items

tag_root <- read_tag_root(file="data/tag_root.csv", encoding = "Big5")

# clear and unique --------------------------------------------------------

## remove coupon item
item_names <- item_names[!grepl("扣抵", item_names)]
item_unique_wo_unit <- unique(remove_unit(to_halfwidth(item_names)))
# writeLines(item_unique_wo_unit, "item_unique.txt")  # output for n-gram

# tagging -----------------------------------------------------------------

# tag_item("海水魚a", tag_root, 0.2)
sample_data <- sample(item_unique_wo_unit, 500)
temp <- lapply(sample_data,
               function(x) output <- tag_item(x, tag_root, threshold=0.3))
names(temp) <- sample_data
table(sapply(temp, length)) # freq

temp[sapply(temp, function(x) length(x)==1)]


