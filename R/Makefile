# run `make` to build graphs/analyses

##
# INPUT FILE LOCATIONS
#

OTU_TABLE='../data/otu-tables/dipp-hiseq-samples.gg97.minlen70.50r10s.csv'

ifeq ($(TAXCOLLECTOR), 'true')
  TAXONOMIES?='../data/taxonomy-tables/greengenes-with-taxcollector-taxonomy.csv'
else
  TAXONOMIES?='../data/taxonomy-tables/greengenes-taxonomies-merged-bacteroides.csv'
endif

# miseq data
MISEQOTUS?='../data/miseq-tc97.minlen275.50r10s.csv'

SUBJECT_DATA?='../data/dipp-subjects.csv'
SAMPLE_DATA?='../data/dipp-stool-samples.csv'
SEQUENCING_DATA?='../data/dipp-sequencing-runs.csv'

TREE?='../data/phylogenetic-trees/97-otus.tree'

##
# MISC PARAMETERS
#

NORMALIZE?='rarefy' # method for correcting for differences in sequencing depth

FDR?='BH' # fdr correction method in glm script
TOP?=4 # top n taxa to plot

BY?=10 # distance between sliding windows in days
WIDTH?=201 # width of sliding window in days

TESTMETHOD?='glm'

default: sliding_window glms boxplots mw-all
	@echo 'done!'

sliding_window_qpcr: sliding-window-qpcr-bacteroides.pdf sliding-window-qpcr-dorei.pdf

sliding_window: sliding-window-Phylum.pdf sliding-window-Genus.pdf sliding-window-Species.pdf sliding_window_qpcr

boxplots: boxplot-Phylum.pdf boxplot-Genus.pdf boxplot-Species.pdf

mw-all: mw-all-Phylum.pdf mw-all-Genus.pdf mw-all-Species.pdf

tables: rank_tables/Phylum.csv rank_tables/Genus.csv rank_tables/Species.csv

# core data object
# generates an rdata file containing a phyloseq dataset w/ main
# experimental data (subject data, sample data, otu table, taxonomies)
dipp.Rdata:
	bin/write-rdata \
		--unique \
		--output $@ \
		--normalize $(NORMALIZE) \
		--proportion \
		--site Turku \
		--otutable $(OTU_TABLE) \
		--subject-data $(SUBJECT_DATA) \
		--sample-data $(SAMPLE_DATA) \
		--sequencing-data $(SEQUENCING_DATA) \
		--taxonomies $(TAXONOMIES) \
		--proportion

sliding-window-diversity.pdf: dipp-for-richness.RData
	bin/sliding-window-diversity \
		--input $< \
		--output $@ \
		--width 200 \
		--method Shannon

# figure 1
glms: glm-Phylum.pdf glm-Genus.pdf glm-Species.pdf

# figure 4
autoimmunity-timing.pdf:
	bin/autoimmunity-timing
	mv Rplots autoimmunity-timing.pdf

# S Fig XX
mw-all-%.pdf: dipp.RData
	bin/all-sample-mw-test \
		--input $< \
		--pdf $@ \
		--rank $* \
		--table-out mw-all-$*.csv

# figure 1 a, b, c
glm-%.pdf: dipp.RData
	bin/full-glm \
		--input $< \
		--output "$@".csv \
		--pdf $@ \
		--rank $* \
		--out-table glm-$*.csv

# unused (throw away?)
boxplot-%.pdf: dipp.RData
	bin/boxplots \
		--start 300 \
		--stop 500 \
		--rank $* \
		--output $@ \
		--input $<

# for figure 4 b, c
dipp-miseq.RData:
	bin/write-rdata \
	    --unique \
	    --output $@ \
	    --normalize $(NORMALIZE) \
	    --otutable $(MISEQOTUS) \
	    --metadata $(METADATA) \
	    --taxonomies $(TAXONOMIES) \
	    --proportion

# Figure 2 a, b, c
sliding-window-%.pdf: dipp.RData
	bin/sliding-window-smooth \
		--rank $* \
		--output $@ \
		--input $< \
		--width $(WIDTH) \
		--top $(TOP) \
		--by $(BY)

# For Figure 3 b, c
dipp-qpcr-%.RData:
	bin/write-rdata \
		--unique \
		--output $@ \
		--otutable ../data/$*.csv \
		--metadata $(METADATA) \
		--taxonomies $(TAXONOMIES) \
		--normalize none

# Figure 3b
sliding-window-qpcr-bacteroides.pdf: dipp-qpcr-bacteroides.RData
	bin/sliding-window-smooth \
		--input $< \
		--output $@ \
		--rank Genus \
		--by $(BY) \
		--absolute \
		--width $(WIDTH)

# Figure 3c
sliding-window-qpcr-dorei.pdf: dipp-qpcr-dorei.RData
	bin/sliding-window-smooth \
		--input $< \
		--output $@ \
		--rank Species \
		--by $(BY) \
		--absolute \
		--width $(WIDTH)

# for S. Fig 1 
dipp-for-richness.RData:
	bin/write-rdata \
		--unique \
		--output $@ \
		--normalize rarefaction \
		--otutable $(OTU_TABLE) \
		--metadata $(METADATA) \
		--taxonomies $(TAXONOMIES)

rank_tables:
	mkdir -p rank_tables

# builds OTU tables with names at specific rank
# useful for people who like to stare at Excel
rank_tables/%.csv: rank_tables dipp.RData
	bin/make-rank-table \
	    --rank $* \
	    --output $@ \
	    --input dipp.RData

clean:
	rm -f *.RData
	rm -f *.pdf
