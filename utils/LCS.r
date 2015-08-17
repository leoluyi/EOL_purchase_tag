# https://en.wikipedia.org/wiki/Longest_common_subsequence_problem
# http://www.csie.ntnu.edu.tw/~u91029/LongestCommonSubsequence.html

LCS <- function (s, t) {

  m <- length(s)
  n <- length(t)

  if (m==0 | n==0)
    return("")

  L <- array(NA, dim = c(m, n))
  rownames(L) <- s
  colnames(L) <- t

  z <- 0

  for (i in 1:m) {
    for (j in 1:n) {
      if (s[i] == t[j]) {
        if (i == 1 | j == 1) {
          L[i, j] <- 1
        } else
          L[i, j] <- L[i-1, j-1] + 1

        if (L[i, j] > z) {
          z <- L[i, j]
          ret <- s[(i-z+1):i]
        } else if (L[i, j] == z)
          ret <- c(ret, s[(i-z+1):i])
      } else
        L[i, j] <- 0
    }
  }
  return(ret)
}

