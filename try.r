# packages required: data.table, dplyr, qualV, RWeka

library(dplyr)
library(ggplot2)
source("utils/remove_unit.r", encoding = "UTF-8")
source("utils/read_tag_root.r", encoding = "UTF-8")
source("utils/to_halfwidth.r", encoding = "UTF-8")
source("utils/tagging.r", encoding = "UTF-8")
source("utils/string_sim.r", encoding = "UTF-8")

# load file ---------------------------------------------------------------

item_names <- readLines("data/item_names.txt", encoding = "UTF-8")

length(item_names) # 977952 records
length(unique(item_names)) # 62555 items

tag_root_list <- read_tag_root(file="data/tag_root.tsv", encoding = "UTF-8")

key_dominant <- readLines("data/key_dominant.txt", encoding = "UTF-8")

# clear and unique --------------------------------------------------------

## remove coupon item
item_names <- item_names[!grepl("扣抵", item_names)]
item_unique_wo_unit <- unique(remove_unit(to_halfwidth(item_names)))
# writeLines(item_unique_wo_unit, "result/item_unique.txt")  # output for n-gram

# tagging test -----------------------------------------------------------

sample_data <- sample(item_unique_wo_unit, 200)
temp <- sample_data %>% add_tags_snowfall(tag_root_list,
                                 dominant_keys=key_dominant,
                                 threshold=0.43)

## inspect
table(sapply(temp, length)) # tag_count
temp[sapply(temp, function(x) length(x)>=4)]
temp[sapply(temp, function(x) length(x)==1)]

ggplot(data.frame(tag_count=sapply(temp, length)), aes(tag_count)) +
  aes(y = (..count..)/sum(..count..)) +
  geom_histogram(binwidth = 1)


## check zero-tag items
temp[sapply(temp, function(x) length(x)==0)]


# tagging all --------------------------------------------------------------

library (snowfall)
ptm <- proc.time()
sfInit (parallel=TRUE , cpus=4, type = "MPI")
sfExport(list=list("item_tags","tag_root_list","is_tag",
                   "key_dominant","string_sim"))
items_with_tag_all <- item_unique_wo_unit %>%
  add_tags_snowfall(tag_root_list=tag_root_list,
                    dominant_keys=key_dominant,
                    threshold=0.43)
sfStop()
proc.time() - ptm
# save(items_with_tag_all, file = "result/items_with_tag_all.RData")

# items_with_tag_all <- item_unique_wo_unit %>%
#   add_tags(tag_root_list=tag_root_list,
#                     dominant_keys=key_dominant,
#                     threshold=0.43)
# save(items_with_tag_all, file = "result/items_with_tag_all.RData")

## inspect
table(sapply(items_with_tag_all, length)) # tag_count

## check zero-tag items
# temp[sapply(items_with_tag_all, function(x) length(x)==0)]


# plot --------------------------------------------------------------------

# sample_data <- sample(item_unique_wo_unit, 40000)

result <- data.frame()
for (i in seq(0.4, 0.5, by = 0.01)) {

  temp <- sapply(item_unique_wo_unit,
                 function(x) {output <- tag_item(x, tag_root_list, threshold=i)},
                 simplify = FALSE, USE.NAMES = TRUE)

  result <- dplyr::bind_rows(
    result,
    dplyr::data_frame(tag_count=sapply(temp, length), thre=as.character(i)))
}

ggplot(result, aes(x=tag_count, y=..density..,fill=thre, colour=thre, group =thre)) +
  # geom_density(alpha=0.1, posiCtion="identity", adjust=2) +
  geom_histogram(alpha=0.1, position="identity", binwidth=1) +
  scale_x_discrete(breaks=0:40)

names(temp) <- item_unique_wo_unit
# capture.output(
#   names(temp)[sapply(temp, function(x) length(x)==0)], file = "./result/empty_item.txt")


# write empty -----------------------------------------------------------------

load("temp.RDS")
item_empty_tag <- names(temp)[sapply(temp, function(x) length(x)==0)]
writeLines(item_empty_tag, "result/empty_item.txt")
