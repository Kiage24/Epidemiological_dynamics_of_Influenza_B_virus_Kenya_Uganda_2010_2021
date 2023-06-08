#!/usr/bin/bash


refFiles=../data/run1/reference/*.fasta

for refFile in $refFiles

do

refFilename=$(basename -s '.fasta' $refFile)

consensus=../results/concatenated/ivar/$refFilename/*.fa

for sequence in $consensus

do 

barcodename=`basename -s .fa $sequence`

seqlen=`cat $sequence | grep -v '^>' | grep -v '-' | wc -c` 

echo $barcodename','$seqlen >> ../results/concatenated/ivar/$refFilename/${refFilename}.csv

done
done
