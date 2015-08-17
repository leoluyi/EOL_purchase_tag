
tag_brand_list <- lapply(unlist(tag_root, use.names = FALSE), function(x) {
  item_unique_wo_unit[grep(x, item_unique_wo_unit)]
})

names(tag_brand_list) <- unlist(tag_root, use.names = FALSE)

capture.output(tag_brand_list, file = "tag_brand_list.txt")

