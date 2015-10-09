library(dplyr)
source("utils/remove_unit.r", encoding = "UTF-8")
source("utils/read_tag_root.r", encoding = "UTF-8")
source("utils/to_halfwidth.r", encoding = "UTF-8")
source("utils/tagging.r", encoding = "UTF-8")
source("utils/string_sim.r", encoding = "UTF-8")


# load file ---------------------------------------------------------------

item_names <- readLines("data/item_names.txt", encoding = "UTF-8")

length(item_names) # 977952 records
length(unique(item_names)) # 62555 items

tag_root <- read_tag_root(file="data/tag_root.csv", encoding = "Big5")


#  ------------------------------------------------------------------------

tag_item_list <- sapply(
  unlist(tag_root, use.names = FALSE),
  function(x) {
    item_unique_wo_unit[grep(x, item_unique_wo_unit)]
  },
  simplify = FALSE, USE.NAMES = TRUE
)
# names(tag_item_list) <- unlist(tag_root, use.names = FALSE)
dir.create("./result", showWarnings = FALSE)
capture.output(tag_brand_list, file = "./result/tag_item_list.txt")


# brand ------------------------------------------------------------------

brands <- readLines("data/brand_list.txt", encoding = "UTF-8")
brand_item_list <- sapply(
  brands,
  function(x) {
    item_unique_wo_unit[grep(x, item_unique_wo_unit)]
  },
  simplify = FALSE, USE.NAMES = TRUE
)
# names(brand_item_list) <- brands
dir.create("./result", showWarnings = FALSE)
capture.output(brand_item_list, file = "./result/brand_item_list.txt")
