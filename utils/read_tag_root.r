read_tag_root <- function (file, encoding="UTF-8") {

  path <- check_file(file)
  ext <- tolower(tools::file_ext(path))

  file_con <- file(file, encoding = encoding)

  sep <- switch(ext,
                csv = ",",
                tsv = "\t"
  )

  tag_root <- strsplit(readLines(file_con, encoding = "UTF-8"),
                       split = sep)
  close(file_con)

  tag_root <- lapply(tag_root, function(x) gsub("\"", "", x))

  tag_names <- sapply(tag_root, function(x) x[[1]])

  tag_root_list <- sapply(tag_root,
                          function(x) {
                            x <- x[-1]
                            unique(x[x != ""])
                          },
                          simplify = FALSE
  )

  names(tag_root_list) <- tag_names

  tag_root_list
}



# utils -------------------------------------------------------------------

check_file <- function(path) {
  if (!file.exists(path)) {
    stop("'", path, "' does not exist",
         if (!is_absolute_path(path))
           paste0(" in current working directory ('", getwd(), "')"),
         ".",
         call. = FALSE)
  }

  normalizePath(path, "/", mustWork = FALSE)
}

