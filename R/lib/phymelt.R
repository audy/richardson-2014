phymelt <- function(phy) {
  dat <- data.frame(sample_data(phy))
  otu <- data.frame(otu_table(phy), check.names=F)
  colnames(otu) <- 'Abundance'
  merge(dat, otu)
}
