# R Code

## Requirements

[R](http://www.r-project.org) version 3.0 with the following
requirements:

- optparse v1.0.2
- phyloseq v1.6.1
- ggplot2 v0.9.3.1
- reshape2 v1.2.2
- plyr v1.8.1
- perm v1.0.0.0

## Instructions

- `make` - plot all the plots.
- `make -j 24` - quickly plot all the plots.

## Details

First run `bin/write-rdata` to load the OTU table, metadata, and
taxonomies into R and create a Phyloseq object and write this object to
`stdout`. The rest of the scripts take this object as input.  This way
you can be sure the number of samples is consistent between scripts. It
also has the added benefit of making things a lot faster.

### Example

```sh

bin/write-rdata \
  --otutable otus.csv \
  --metadata metadata.csv \
  --taxonomies taxonomies.csv \
  # rarefy to 10k reads per sample \
  # excludes samples with < 10k reads \
  --rarefy 10000 \
  --output experiment.RData

bin/sliding-window-smooth \
  --input experiment.Rdata \
  --rank Genus \
  --output sliding-window-Genus.pdf \
  # number of windows \
  --cuts 12 \
  # plot only top n Genera \
  --top 12
```

# License

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
