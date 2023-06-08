#!/usr/bin/bash

IRMA_output=`ls ../flub_results/IRMA_results/*_trimmed/*.fasta`

for fastafile in $IRMA_output
do

fastafilename=`basename -s fasta $fastafile`
sampleid=`echo $fastafile | cut -f 4 -d / |sed s/_trimmed//` 

seglen=`cat $fastafile | grep -v '^>' | grep -v '-' | wc -c` 

echo $sampleid','$fastafilename','$seglen >> ../flub_results/flub_seglength.csv

done

