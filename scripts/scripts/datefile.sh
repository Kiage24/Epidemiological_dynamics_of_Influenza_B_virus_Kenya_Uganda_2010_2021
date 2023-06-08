#!/usr/bin/bash

headers=`cat ../results/IRMA/mafft/HA_edited.fa | grep "^>"`
echo $headers 

for header in $headers

do

header=`echo $header | sed s/"_"/"|"/g`
sample_id=`echo $header | cut -f "1" -d "|"`
location=`echo $header | cut -f "2" -d "|"`
date=``






done