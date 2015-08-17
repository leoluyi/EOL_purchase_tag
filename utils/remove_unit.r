remove_unit <- function(x) {
  x <- gsub("^\\s+|\\s+$", "", x) # trim
  x <- gsub("[(]?[0-9]*(\\.[0-9 ])*\\s*(l|L|ml|ML|g|G|cc|公斤|公克|公升|入)[\\s)]?(\\s*/\\s*[罐瓶組包粒盒])?$", "", x) # 123 ml
  x <- gsub("[(][大中小粗細][)]$", "", x)
  x <- gsub("^\\s+|\\s+$", "", x) # trim

  x
}


# remove_unit(c("康寶獨享杯(10ml)", "Biore 淨嫩沐浴乳抗菌光澤型 1000ml"))
# remove_unit(to_halfwidth("百齡罈8年調和式麥芽蘇格蘭威士忌"))
# remove_unit("Biore 淨嫩沐浴乳抗菌光澤型 1000ml")
# remove_unit("BLUE GIRL藍妹啤酒 330ml/罐")
