#!/usr/bin/env rscript
plot_timeseries <- function(g, x=NULL, y=NULL, color=NULL) {
    mdf <- psmelt(g)

  p <- ggplot(mdf, aes_string(y='Abundance', x=x, color=color)) + geom_smooth()

    return(p)
}
