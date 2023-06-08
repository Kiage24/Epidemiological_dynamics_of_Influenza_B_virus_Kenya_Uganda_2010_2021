
#!/usr/bin/bash

export PATH=$PATH:/Users/sodoyo/IRMA/flu-amd

#mkdir -p irma_results

fastqs=`ls ../data/flub_trimmed/*R1_trimmed.fastq`

# Unzip the fastq files
for fastq in $fastqs
do

R1=$fastq
R=`basename -s _R1_trimmed.fastq $fastq`
R2=`echo "../data/flub_trimmed/"$R"_R2_trimmed.fastq"`



#Assembling the files using IRMA tool

IRMA FLU $R1 $R2 irma_results/$R 

done

