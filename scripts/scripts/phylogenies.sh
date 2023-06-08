#!/usr/bin/bash

segnames="PB1 PB2 PA HA NA MP NP NS"


mkdir -p ../flub_results/{mafft,iqtree_ml}

for segment in $segnames

do

# #Concatenate sequences with reference strain sequences
# echo "Concatenating sequences with reference strain sequences"

cat ../flub_results/renamed_vic/${segment}_samples.fa >> ../data/gisaid/vic_totalsubsamp/${segment}_victotalsubsamp.fa 

# #Conduct alignment with mafft
# echo 'Conducting alignment with mafft'

#mafft --auto ../data/gisaid/vic_totalsubsamp/${segment}_victotalsubsamp.fa > ../flub_results/aligned_total/vic/${segment}_victotalaln.fa
 
# echo 'mafft analysis complete' 

#Generate trees with iqtree after editing the alignments

# echo "Generating phylogenies with iqtree"

iqtree -s ../flub_results/genotyping/mafft/${segment}_completedit.fa -m MFP -B 1000 --prefix ../flub_results/genotyping/iqtree/${segment}

# echo "iqtree analysis complete"

# #Generate timetrees with iqtree after editing the alignments

# echo "Generating time phylogenies with iqtree"

#iqtree -s  --date TAXNAME ../results/IRMA/mafft/${segment}_edited.fa -m MFP -B 1000 --prefix ../results/IRMA/iqtree/${segment}_time

# echo "iqtree analysis complete"

#Generate timetrees with treetime

#treetime --tree ../flub_results/iqtree_ml/${segment}_tree.nwk --dates ../flub_results/treetime/${segment}_metadata.tsv --aln ../flub_results/mafft/${segment}_edited1.fa --outdir ../flub_results/treetime/${segment}_treetime3

#echo "Timetree analysis complete"

done

