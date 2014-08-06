lowest_rank <- function(phy) {
  rn <- tax_table(phy)
  cn <- colnames(rn[,colSums(is.na(rn)) != nrow(rn)])
  tail(cn, 1)
}

top_n_taxa <- function(phy, n) {
  rank <- lowest_rank(phy)
  keep <- names(sort(taxa_sums(phy), T))[1:n]
  prune_taxa(keep, phy)
}
