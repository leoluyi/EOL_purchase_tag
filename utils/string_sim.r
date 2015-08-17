str1ng_sim <- function(str1, str2) {

  str1 <- as.character(str1[[1]])
  str2 <- as.character(str2[[1]])

  len_str1 <- length(str1)
  len_str2 <- length(str2)

  if (length(str1) == 0 || length(str2) == 0)
    return(integer(0))

  ## split char by char
  str1 <- unlist(strsplit(str1, ""))
  str2 <- unlist(strsplit(str2, ""))

  ## calculate Longest Common Subsequence (LCS)
  lcs <- qualV::LCS(str1, str2)

  if (lcs$LLCS != 0) {
    m <- max(len_str1, len_str2)
    n <- min(len_str1, len_str2)
    QSI_by_root <- lcs$LLCS / (m*0.8 + n*0.2)
  } else
    QSI_by_root <- 0

  QSI_by_root

  # lcs$QSI

}

