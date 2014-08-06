lowest_rank <- function(phy) {
  rn <- tax_table(phy)
  cn <- colnames(rn[,colSums(is.na(rn)) != nrow(rn)])
  tail(cn, 1)
}

top_n_taxa <- function(phy, n) {
  rank <- lowest_rank(phy)
  top_phy <- sort(tapply(taxa_sums(phy), tax_table(phy)[,rank], sum),
                  decreasing=TRUE)[1:n]
  form <- parse(text=paste(rank, '%in%', 'names(top_phy)'))
  cat("top", n, rank, ":", names(top_phy), "\n")
  subset_taxa(phy, eval(form))
}
