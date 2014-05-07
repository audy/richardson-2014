# generate subsets across a sliding window
# return subsets as a list
generate_subsets <- function(phy, window_range, window_size) {
  subsets = list()
  for (i in window_range) {
    d <- window_size / 2.0
    i <- i - d
    j <- i + d
    meta <- data.frame(phy@sam_data)
    meta <- meta[meta[,'age_at_sampling'] >= i,]
    meta <- meta[meta[,'age_at_sampling'] <= j,]
    if (nrow(meta) < 10) { next; }
    ss <- phy
    sample_data(ss) <- sample_data(meta)
    subsets <- cbind(subsets, ss)
  }
  return(subsets)
}
