read_tag_root <- function (file, encoding="UTF-8") {

  tag_root <- strsplit(readLines(file, encoding = encoding),
                       split = ",")

  tag_names <- sapply(tag_root, function(x) x[[1]])

  tag_root_list <- lapply(tag_root,
                          function(x) {
                            x <- x[-1]
                            unique(x[x != ""])
                          })

  names(tag_root_list) <- tag_names

  tag_root_list
}
