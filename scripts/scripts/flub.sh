
#!/usr/bin/bash

##quality check with pycoqc

#echo 'Running pycoqc'

#pycoQC -f ../data/sequencing_summary_FAH91062_93e67e17.q -o ../results/pycoQC_output.html

#echo 'pycoqc complete'

##Trimming of read adapters by porechop

FILES=../data/run1/fastq_pass/barcode*/*
mkdir -p ../results/run1/porechop_trimmed


echo 'Trimming adapters'
echo 'Beginning analysis'

for file in $FILES;

do

fastq=`basename -s 'fastq.gz' $file`
barcode=`cut -f 3 -d '_' <<< $fastq`
output=`echo $fastq'_trimmed.fastq.gz'`

mkdir -p ../results/run1/porechop_trimmed/$barcode

porechop -i $file -o ../results/run1/porechop_trimmed/$barcode/$output

echo 'completed trimming for $file'
done

echo 'completed analysis for porechop'
