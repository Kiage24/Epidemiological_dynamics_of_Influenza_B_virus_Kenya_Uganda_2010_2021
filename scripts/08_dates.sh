#!/usr/bin/bash

#Obtain the locations from the labels

ref_labels=`cat ../flub_results/iqtree_global/vic/ss2_labels.txt |grep "B/"`


for ref_label in $ref_labels

do

dates=`echo $ref_label | cut -d "|" -f 4 | cut -d "-" -f 1`

echo $ref_label","$dates >> ../flub_results/iqtree_global/vic/ss2_dates.csv

done

sample_labels=`cat ../flub_results/iqtree_global/vic/ss2_labels.txt |grep -v  "B/"`


for sample_label in $sample_labels

do

sample_dates=`echo $sample_label | cut -d "|" -f 3 | cut -d "-" -f 1`

echo $sample_label","$sample_dates >> ../flub_results/iqtree_global/vic/ss2_dates.csv

done

