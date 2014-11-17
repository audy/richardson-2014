# DIPP Turku Analysis

After cloning this repo, download the data:

`git submodule update --init --recursive`

# Installation

R v3.1.1 with dependencies:

- Phyloseq 

```R
source("http://bioconductor.org/biocLite.R")
biocLite("phyloseq") # grab some tea
```

- dplyr, plyr, ggplot2, reshape2, magrittr

```R
install.packages(c('dplyr', 'plyr', 'ggplot2', 'reshape2', 'magrittr'))
```

## Instructions for generating figures

All figures require an RData file which contains the OTU abundance data as well
as sample metadata. This file is created using the script `bin/write-rdata`. To
generate the RData used in this work, run the command `make dipp-rf-uniq.RData`
from the `R/` directory.

### Figure 1 - Time Series Analysis (GLM)

`make glms`

### Figure 2 - Time Series Analysis (sliding window)

`make sliding_window`

### Figure 3 - 16S, 23S rRNA Phylogenetic tree

I didn't automate this step. Sorry.

### Figure 4 - Timing of Autoimmunity

`make autoimmunity-timing.pdf`


## License

The MIT License (MIT)

Copyright (c) 2014 Austin G. Davis-Richardson

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

