#!/usr/bin/env rscript

library(phyloseq)

'load.dipp' <- function(otu.table=NULL, subject.data=NULL, sample.data=NULL,
                        sequencing.data = NULL, tax.table=NULL, tree=NULL) {

  otus <- otu_table(read.csv(otu.table, header=T, row.names=1, check.names=F), taxa_are_rows=F)

  meta <- load_dipp_metadata(subject_data= subject.data,  sample_data=
                             sample.data, sequencing_data = sequencing.data)

  # has to match otu table
  rownames(meta) <- meta$sequence_id

  meta <- sample_data(meta)
  taxa <- read.csv(tax.table, header=T, row.names=1)

  taxa <- tax_table(as.matrix(taxa))

  if (!is.null(tree)) tree <- read_tree_greengenes(tree)

  phyloseq(otus, meta, taxa, tree)
}

fix_subject_columns <- function(sd) {
    sd$DOB <- as.Date(sd$DOB, '%m/%d/%y')
    sd$date_ICA <- as.Date(sd$date_ICA, '%m/%d/%y')
    sd$date_GADA <- as.Date(sd$date_GADA, '%m/%d/%y')
    sd$date_IA2A <- as.Date(sd$date_IA2A, '%m/%d/%y')
    sd$date_IAA <- as.Date(sd$date_IAA, '%m/%d/%y')
    sd$date_T1D <- as.Date(sd$date_T1D, '%m/%d/%y')
    sd$date_first_sc <- as.Date(sd$date_first_sc, '%m/%d/%y')
    return(sd)
}

# coerve columns
fix_sample_columns <- function(df) {
    df$sample_date <- as.Date(df$sample_date, '%m/%d/%y')
    return(df)
}

compute_derived_columns <- function(df) {
    df <- within(df, age_at_sampling <- as.numeric(sample_date - DOB))
    return(df)
}

merge_tables <- function(samples, subjects, sequences) {
  m1 <- merge(sequences, samples, by.x='sample_id', by.y='sample_id')
  merged <- merge(subjects, m1, by.x='dipp_person', by.y='dipp_person')
}

# practice merging

load_dipp_metadata <- function(sample_data=NULL, subject_data=NULL,
                               sequencing_data=NULL) {
  samples <- fix_sample_columns(read.csv(sample_data))
  subjects <- fix_subject_columns(read.csv(subject_data))
  sequencings <- read.csv(sequencing_data)
  merged <- merge_tables(samples, subjects, sequencings)
  fixed <- compute_derived_columns(merged)
}
