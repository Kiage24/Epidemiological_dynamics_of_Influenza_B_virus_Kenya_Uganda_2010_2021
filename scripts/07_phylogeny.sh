#!/usr/bin/bash

segnames="PB1 PB2 PA HA NA MP NP NS"


mkdir -p ../flub_results/{mafft,iqtree_ml}


#Generate trees with iqtree after editing the alignments

echo "Generating phylogenies with iqtree"

for segment in $segnames

do

iqtree -s ../flub_results/genotyping/mafft/${segment}_completedit.fa -m MFP -B 1000 --prefix ../flub_results/genotyping/iqtree/${segment}

echo "iqtree analysis complete"

done


