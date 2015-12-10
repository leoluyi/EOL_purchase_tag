# packages required: data.table, dplyr, qualV, RWeka

library(dplyr)
library(ggplot2)

source("utils/tagging.r", encoding = "UTF-8")
source("utils/string_sim.r", encoding = "UTF-8")


# read data ---------------------------------------------------------------

source("read_data.r", encoding = "UTF-8")


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

# items_with_tag_all <- lapply(items_with_tag_all, function(x) gsub("^\ufeff", "", x)) # remove \ufeff
# save(items_with_tag_all, file = "result/items_with_tag_all.RData")

# items_with_tag_all <- item_unique_wo_unit %>%
#   add_tags(tag_root_list=tag_root_list,
#                     dominant_keys=key_dominant,
#                     threshold=0.43)


## == parallel computing == #
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
# =================== #

head(items_with_tag_all)

## inspect
table(sapply(items_with_tag_all, length)) # tag_count

## check zero-tag items
# names(items_with_tag_all)[sapply(items_with_tag_all, function(x) length(x)==0)]


# save result -------------------------------------------------------------

# save(items_with_tag_all, file = "result/items_with_tag_all.RData")


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


# write empty -----------------------------------------------------------------

item_empty_tag <- names(temp)[sapply(temp, function(x) length(x)==0)]
writeLines(item_empty_tag, "result/empty_item.txt")
