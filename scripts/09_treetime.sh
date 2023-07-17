#!/usr/bin/bash

segnames="PB1 PB2 PA HA NA MP NP NS"

for segment in $segnames

do

#Check for temporal signals with timetree

treetime --tree ../flub_results/genotyping/iqtree/${segment}_tree.nwk  --dates ../flub_results/genotyping/treetime/${segment}_vicdates.tsv  --aln ../flub_results/genotyping/mafft/${segment}_completedit.fa   --outdir ../flub_results/genotyping/treetime/${segment}

done
