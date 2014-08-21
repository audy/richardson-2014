# find lowest rank in the taxonomy table
lowest_rank <- function(phy) {
  rn <- tax_table(phy)
  cn <- colnames(rn[,colSums(is.na(rn)) != nrow(rn)])
  tail(cn, 1)
}

# return top n taxa
top_n_taxa <- function(phy, n) {
  rank <- lowest_rank(phy)
  keep <- names(sort(taxa_sums(phy), T))[1:n]
  prune_taxa(keep, phy)
}

# remove technical replicates by taking the sample with
# the most number of reads
unique_samples <- function(phy) {
  library(plyr)
  meta <- data.frame(sample_data(phy), check.names=F)

  # ddply drops rownames.
  meta$illumina_id <- rownames(meta)

  # get total number of reads
  meta$total_reads <- rowSums(otu_table(phy))

  uniqued <- ddply(meta, ~sample_id, function(x) {
        # sort by total reads in descending order
        sorted <- x[with(x, order(-total_reads)),]
        sorted[1,]
  })

  # put back rownames.
  rownames(uniqued) <- uniqued$illumina_id
  phy <- phyloseq(sample_data(uniqued), otu_table(phy), tax_table(phy))
}
