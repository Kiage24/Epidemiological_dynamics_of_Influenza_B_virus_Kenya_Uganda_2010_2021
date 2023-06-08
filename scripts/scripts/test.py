import sys
import random
sys.path.append('/Applications/biopython-1.62b')
sys.path.append('/Users/technician/Desktop/bioinformatic+programming/handy_scripts/python')
sys.path.append("/Applications/biopython-1.65")
import fasta
import re

infile = sys.argv[1]
rand = int(sys.argv[2])
outfile = sys.argv[3]

infh = open(infile, 'r')
fasta = {header: sequence for header, sequence in fasta.fasta_iterator(infh)}
infh.close()
headers=" ".join(list(fasta.keys()))
#print(headers)
outfh = open(outfile, 'w')
for i in range(0, rand):
    k = random.choice(list(fasta.keys()))
    #for j in range(len(headers)):
    id="_".join(k.split('_')[:-1])
    
    x = "_\w+"
    pattern = id +x
    
   # print(pattern)
    #allid=re.findall(r'(B/Nigeria/3352/2018\|EPI_ISL_330532\|Africa\| Nigeria\|2018-01-16\|Victoria\|...)',headers)
    allid=re.findall(pattern, headers)
    # print(allid)
    for j in allid:
        # print(j)
        outfh.write(">%s\n%s\n" % (j, fasta[j]))
        fasta.pop(j)
outfh.close()
    #print(allid)
    # break
        

        




