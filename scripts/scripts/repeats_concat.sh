
#!/usr/bin/bash

ids=`cat ../data/repeats2.csv`

for id in $ids
do

sampleid=`cut -f 1 -d ',' <<< $id`
run1barcode=`cut -f 2 -d ',' <<< $id`
run2barcode=`cut -f 3 -d ',' <<< $id`

cp ../results/run1/porechop/${run1barcode}_trimmed.fastq ../data/repeats/
cp ../results/run3/porechop/${run2barcode}_trimmed.fastq ../data/repeats/

cat ../data/repeats/${run1barcode}_trimmed.fastq >> ../data/repeats/concatenated/${sampleid}_trimmed.fastq
cat ../data/repeats/${run2barcode}_trimmed.fastq >> ../data/repeats/concatenated/${sampleid}_trimmed.fastq

done

