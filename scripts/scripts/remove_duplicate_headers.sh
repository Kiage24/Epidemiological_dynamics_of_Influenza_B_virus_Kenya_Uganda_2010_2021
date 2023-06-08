#!/bin/bash

#This script removes fasta files with the same headers

display_usage() { 
	printf "\nThis script must be run with the input and output file arguments.\n"
        printf "i.e. sh remove_duplicate_headers.sh <input> <output>\n\n"
	}

if [  $# -le 1 ] 
	then 
	display_usage
	exit 1
fi


INPUT_FILE=$1
OUTPUT_FILE=$2

awk '/^>/{f=!d[$1];d[$1]=1}f' $INPUT_FILE > $OUTPUT_FILE
