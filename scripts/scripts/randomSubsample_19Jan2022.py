#! /usr/bin/python

import sys
import random
sys.path.append('/Applications/biopython-1.62b')
sys.path.append('/Users/technician/Desktop/bioinformatic+programming/handy_scripts/python')
sys.path.append("/Applications/biopython-1.65")
import fasta

if len(sys.argv) != 4:
	print("[USAGE]: random_sub_sample.py <infile.fas> <number_of_records> <outfile.fas>")
	sys.exit(0)

infile = sys.argv[1]
rand = int(sys.argv[2])
outfile = sys.argv[3]

infh = open(infile, 'r')
fasta = {header: sequence for header, sequence in fasta.fasta_iterator(infh)}
infh.close()

outfh = open(outfile, 'w')
for i in range(0, rand):
	
	k = random.choice(list(fasta.keys()))
	outfh.write(">%s\n%s\n" % (k, fasta[k]))
	fasta.pop(k)
outfh.close()