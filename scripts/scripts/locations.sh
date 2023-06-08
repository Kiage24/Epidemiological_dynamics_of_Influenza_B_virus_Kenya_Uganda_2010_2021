#!/usr/bin/bash

#Obtain the locations from the labels

ref_labels=`cat ../flub_results/genotyping/phylogeny/HA_labels.txt|grep "B/"`


for ref_label in $ref_labels

do 

location=`echo $ref_label | cut -d "/" -f 2` 

echo $ref_label","$location >> ../flub_results/genotyping/phylogeny/locations.csv

done 

sample_labels=`cat ../flub_results/genotyping/phylogeny/HA_labels.txt|grep -v  "B/"`


for sample_label in $sample_labels

do

sample_location=`echo $sample_label | cut -d "|" -f 2`

echo $sample_label","$sample_location >> ../flub_results/genotyping/phylogeny/locations.csv

done

