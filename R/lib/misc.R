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


# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
