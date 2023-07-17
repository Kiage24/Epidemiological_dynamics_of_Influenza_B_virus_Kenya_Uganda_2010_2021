#!/usr/bin/bash

segnames="PB1 PB2 PA HA NA MP NP NS"


mkdir -p ../flub_results/{mafft,iqtree_ml}

for segment in $segnames

do

# Concatenate sequences with reference strain sequences
echo "Concatenating sequences with reference strain sequences"

cat ../flub_results/renamed_vic/${segment}_samples.fa >> ../data/gisaid/vic_totalsubsamp/${segment}_victotalsubsamp.fa 

# Conduct alignment with mafft
echo 'Conducting alignment with mafft'

mafft --auto ../data/gisaid/vic_totalsubsamp/${segment}_victotalsubsamp.fa > ../flub_results/aligned_total/vic/${segment}_victotalaln.fa
 
echo 'mafft analysis complete' 

done

