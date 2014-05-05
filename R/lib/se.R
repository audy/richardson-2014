# returns standard error given a numeric vector
se <- function(x) {
  if (length(x) == 1) {
    0
  } else {
    sd(x, na.rm=T)/sqrt(length(x))
  }
}
