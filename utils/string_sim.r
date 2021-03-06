string_sim <- function(stri1, stri2) {

  stri1 <- tolower(as.character(stri1[[1]]))
  stri2 <- tolower(as.character(stri2[[1]]))

  ## split char by char
  str1 <- unlist(strsplit(stri1, ""))
  str2 <- unlist(strsplit(stri2, ""))

  if (length(str1) == 0 || length(str2) == 0)
    return(integer(0))

  len_str1 <- length(str1)
  len_str2 <- length(str2)

  ## calculate Longest Common Subsequence (LCS)
  lcs <- qualV::LCS(str1, str2)

  if (lcs$LLCS != 0) {
    m <- max(len_str1, len_str2)
    n <- min(len_str1, len_str2)
    QSI_by_root <- lcs$LLCS / (m*0.1 + n*0.9)
  } else
    QSI_by_root <- 0
  # cat(stri2, "-", lcs$LCS, ": ", QSI_by_root, "\n")
  QSI_by_root

  # lcs$QSI

}

