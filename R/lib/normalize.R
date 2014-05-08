#!/usr/bin/env rscript

# lifted from: http://joey711.github.io/waste-not-supplemental/simulation-cluster-accuracy/simulation-cluster-accuracy-server.html
edgeRnorm = function(physeq, ...) {
    require("edgeR")
    require("phyloseq")

    # Enforce orientation.
    if (!taxa_are_rows(physeq)) {
        physeq <- t(physeq)
    }

    x = as(otu_table(physeq), "matrix")

    # See if adding a single observation, 1, everywhere (so not zeros) prevents
    # errors without needing to borrow and modify calcNormFactors (and its
    # dependent functions) It did. This fixed all problems.  Can the 1 be
    # reduced to something smaller and still work?

    x = x + 1

    # Now turn into a DGEList
    y = edgeR::DGEList(counts = x, remove.zeros = TRUE)

    # Perform edgeR-encoded normalization, using the specified method (...)
    z = edgeR::calcNormFactors(y, ...)

    # A check that we didn't divide by zero inside `calcNormFactors`
    if (!all(is.finite(z$samples$norm.factors))) {
        stop("Something wrong with edgeR::calcNormFactors on this data, non-finite $norm.factors")
    }

    # Don't need the following additional steps, which are also built-in to some
    # of the downstream distance methods. z1 = estimateCommonDisp(z) z2 =
    # estimateTagwiseDisp(z1)

    counts <- t(z[[1]])

    # not throwing anything away so it's okay to just do an
    # in-place replacement of the OTU table
    otu_table(physeq) <- otu_table(counts, taxa_are_rows=FALSE)

    return(physeq)
}
