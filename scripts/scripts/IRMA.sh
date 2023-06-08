#!/usr/bin/env bash

# trimmedfastqs="../results/run4/porechop/*.fastq" 

# mkdir -p ../results/run4/IRMA

# for fastqfile in $trimmedfastqs
# do

# fastqfilename=`basename -s .fastq $fastqfile`

# IRMA FLU-MinION $fastqfile ../results/run4/IRMA/$fastqfilename

# done

# Rename the headers for alignment and concatenate the sequences

segments="PB1 PB2 PA HA NA NP MP NS"

for segment in $segments
do

consensus_fasta=`ls ../flub_results/IRMA_results/*_trimmed/B_${segment}.fasta`

for fastafile in $consensus_fasta
do

sampleid=`echo $fastafile | cut -f 4 -d "/" | sed s/_trimmed//g`
cat $fastafile | sed s/B_${segment}/${sampleid}/g >> ../flub_results/concatenated/${segment}_concat.fasta

done

done

