#!/usr/bin/env rscript

library(phyloseq)

'load.dipp' <- function(otu.table=NULL, sam.data=NULL, tax.table=NULL, tree=NULL) {
  otus <- otuTable(read.csv(otu.table, header=T, row.names=1, check.names=F), taxa_are_rows=F)
  meta <- samData(read.csv(sam.data, header=T, row.names=1))
  taxa <- taxTab(as.matrix(read.csv(tax.table, header=T, row.names=1)))

  if (!is.null(tree)) tree <- read_tree_greengenes(tree)

  phyloseq(otus, meta, taxa, tree)
}
