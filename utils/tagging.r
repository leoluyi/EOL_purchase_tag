is_tag <- function (item, keys, dominant_keys=NULL, threshold) {

  if (!is.null(dominant_keys)) {
    is_match <- sapply(keys, function(x) {
      ifelse(grepl(x, item, ignore.case = TRUE) && x %in% dominant_keys,
             TRUE, FALSE)
    })
    if (any(is_match)) return(TRUE)
  }

  sims <- sapply(keys,
                 function(x) {
                   string_sim(item, x)
                 }, simplify = TRUE, USE.NAMES = FALSE)

  if (max(unlist(sims), na.rm = TRUE) > threshold)
    return(TRUE)
  else
    return(FALSE)
}


item_tags <- function (item, tag_root_list, dominant_keys=NULL, threshold) {

  tags <- sapply(tag_root_list,
                 function(x) {
                   ifelse(is_tag(item, x, dominant_keys, threshold),
                          TRUE,
                          FALSE)
                 }, USE.NAMES = TRUE)

  tags <- unlist(tags)
  names(which(tags))
}


add_tags <- function(data, tag_root_list, dominant_keys=NULL, threshold=0.43) {

  item_tag_list <- sapply(data,
                          function(x) {
                            output <- item_tags(x, tag_root_list,
                                                dominant_keys,
                                                threshold)
                          }, simplify = FALSE, USE.NAMES = TRUE)
  item_tag_list
}

add_tags_snowfall <-  function(data, tag_root_list, dominant_keys=NULL, threshold=0.43) {

  item_tag_list <- snowfall::sfSapply(data,
                                      function(x) {
                                        output <- item_tags(x, tag_root_list,
                                                            dominant_keys,
                                                            threshold)
                                      }, simplify = FALSE, USE.NAMES = TRUE)
  item_tag_list
}
