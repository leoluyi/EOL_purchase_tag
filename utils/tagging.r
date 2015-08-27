is_tag <- function (item, keys, threshold) {

  sims <- sapply(keys,
                 function(x) {
                   string_sim(item, x)
                 })

  if (max(sims, na.rm = TRUE) > threshold)
    return(TRUE)
  else
    return(FALSE)
}


tag_item <- function (item, tag_list, threshold=0.5) {

  tags <- sapply(tag_list,
                 function(x) {
                   if (is_tag(item, x, threshold))
                     TRUE
                   else FALSE
                 })

  names(which(tags))
}
