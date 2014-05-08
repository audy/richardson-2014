# Makefile for running PICRUST calculations

#
# Instructions:
#
# $ make my-otu-table-metagenome.tab
#
# lots of waiting ...
# You have a predicted metagenome!
#

# 1. Convert to qiime-like format, remove unclassified_reads column
# 2. Convert tab file to biom file.
# 3. Normalize by copy number.
# 4. Predict metagenome.
# 5. Convert metagenome biom file to tab-delimited.
# 6. Calculate metagenome contributions

# preseve intermediate biom and tab files
# as some take forever to calculate

# needs to be run from picrust/ directory?
PICRUST?='picrust'

default: predicted-metagenome.tab

.PRECIOUS: otus-qiime.tab
# 1. Convert to qiime-like format.
otus-qiime.tab: ../../data/dipp-otus.csv.gz
	gzcat $< | ./csv-to-qiime.py --remove-unclassified > $@

.PRECIOUS: otus-qiime.biom
# 2. Convert tab to biom
otus-qiime.biom: otus-qiime.tab
	biom convert \
		--table-type 'otu table' \
		--input-fp $< \
		--output-fp $@

.PRECIOUS: otus-normalized.biom
# 3. Normalize by copy number
otus-normalized.biom: otus-qiime.biom
	$(PICRUST)/scripts/normalize_by_copy_number.py \
		--gg_version '13_5' \
		--input_count_fp 16S_13_5_precalculated.tab.gz \
		--input_otu_fp $< \
		--output_otu_fp $@

# Convert normalized OTU table to QIIME tab format
.PRECIOUS: otus-normalized.tab
otus-normalized.tab: otus-normalized.biom
	biom convert \
		--biom-to-classic-table \
		--input-fp $< \
		--output-fp $@

# Convert QIIME Tab table to CSV
.PRECIOUS: otus-normalized.csv
otus-normalized.csv: otus-normalized.tab
	./qiime-to-csv.py \
		< $< \
		> $@


.PRECIOUS: predicted-metagenome.biom
predicted-metagenome.biom: otus-normalized.biom
	$(PICRUST)/scripts/predict_metagenomes.py \
		--input_otu_table $< \
		--output_metagenome_table $@

.PRECIOUS: predicted-metagenome.tab
predicted-metagenome.tab: predicted-metagenome.biom
	biom convert \
		--biom-to-classic-table \
		--input-fp $< \
		--output-fp $@

.PRECIOUS: predicted-metagenome-contributions.tab
predicted-metagenome-contributions.tab: predicted-normalized.biom
	$(PICRUST)/scripts/metagenome_contributions.py \
		--input_otu_table $< \
		--output_fp $@
