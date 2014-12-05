#!/usr/bin/env rscript


'load.dipp' <- function(otu.table=NULL, subject.data=NULL, sample.data=NULL,
                        sequencing.data = NULL, tax.table=NULL, tree=NULL) {

  library(phyloseq)
  otus <- otu_table(read.csv(otu.table, header=T, row.names=1, check.names=F), taxa_are_rows=F)

  meta <- load_dipp_metadata(subject_data= subject.data,  sample_data=
                             sample.data, sequencing_data = sequencing.data)

  # has to match otu table
  rownames(meta) <- meta$sequence_id

  meta <- sample_data(meta)
  taxa <- read.csv(tax.table, header=T, row.names=1)

  taxa <- tax_table(as.matrix(taxa))

  if (!is.null(tree)) tree <- read_tree_greengenes(tree)

  phy <- phyloseq(otus, meta, taxa, tree)
 
  # old school way of getting rid of tech reps
  phy <- consolidate_technical_replicates(phy)

  # remove 1AA cases
  phy <- subset_samples(phy, aa_number != 1)

  phy
}

fix_subject_columns <- function(df) {
    df <- within(df, {
        DOB              <- as.Date(DOB, '%m/%d/%y')
        date_ICA         <- as.Date(date_ICA, '%m/%d/%y')
        date_GADA        <- as.Date(date_GADA, '%m/%d/%y')
        date_IA2A        <- as.Date(date_IA2A, '%m/%d/%y')
        date_IAA         <- as.Date(date_IAA, '%m/%d/%y')
        date_T1D         <- as.Date(date_T1D, '%m/%d/%y')
        date_first_sc    <- as.Date(date_first_sc, '%m/%d/%y')
        age_GADA         <- as.numeric(date_GADA - DOB)
        age_IAA          <- as.numeric(date_IAA - DOB)
        age_IA2A         <- as.numeric(date_IA2A - DOB)
        age_ICA          <- as.numeric(date_ICA - DOB)
        age_T1D          <- as.numeric(date_T1D - DOB)
        vaginal_delivery <- (Mode_of_Delivery %in% c('vaginal', 'suction-cup', 'breech delivery'))
    })
    return(df)
}


consolidate_technical_replicates <- function(phy) {
  subset_samples(phy, !duplicated(sample_id))
}

# coerve columns
fix_sample_columns <- function(df) {
    df <- within(df, {
        sample_date <- as.Date(sample_date, '%m/%d/%y')
    })
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

load_dipp_subject_data <- function(csv_file) {
  fix_subject_columns(read.csv(csv_file))
}

# practice merging

load_dipp_metadata <- function(sample_data=NULL, subject_data=NULL,
                               sequencing_data=NULL) {
  samples <- fix_sample_columns(read.csv(sample_data))
  subjects <- load_dipp_subject_data(subject_data)
  sequencings <- read.csv(sequencing_data)
  merged <- merge_tables(samples, subjects, sequencings)
  fixed <- compute_derived_columns(merged)
}
