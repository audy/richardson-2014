#!/usr/bin/env rscript
library(ggplot2)


ggplot.theme <- theme(panel.background = element_blank(),
                      strip.background = element_blank(),
                      panel.grid.major = element_line(),
                      panel.grid.minor = element_blank(),
                      axis.line = element_line(),
                      legend.position='bottom')

ggplot.pal.scale <- scale_fill_manual(values=c("#FFAB00", # cases
                                             "#999999") # controls
                                        )


ggplot.pal.sig <-
  scale_colour_manual(values=c("#FFFFFF", "#218457" ))
