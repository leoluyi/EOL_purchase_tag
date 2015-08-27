read_tag_root <- function (file, encoding="UTF-8") {

  file_con <- file(file, encoding = encoding)
  tag_root <- strsplit(readLines(file_con, encoding = "UTF-8"),
                       split = ",")

  close(file_con)

  tag_names <- sapply(tag_root, function(x) x[[1]])

  tag_root_list <- lapply(tag_root,
                          function(x) {
                            x <- x[-1]
                            unique(x[x != ""])
                          })

  names(tag_root_list) <- tag_names

  tag_root_list
}
