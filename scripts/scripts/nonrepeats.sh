
#!/usr/bin/bash

ids=`cat ../data/run3_nonrepeats1.csv`

for id in $ids
do

sampleid=`cut -f 2 -d ',' <<< $id`
run1barcode=`cut -f 3 -d ',' <<< $id`


cp ../results/run3/porechop/${run1barcode}_trimmed.fastq ../data/run3_nonrepeats/
mv ../data/run3_nonrepeats/${run1barcode}_trimmed.fastq ../data/run3_nonrepeats/${sampleid}_trimmed.fastq

done
