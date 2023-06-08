
#!/usr/bin/env bash
 
# Install minimap2

#conda install -y -c bioconda minimap2
 
# Install samtools

#conda install -y -c bioconda samtools openssl=1.0

# Install bcftools

#conda install -c  bioconda bcftools libdeflate=1.0

# Install ivar

#conda install -c bioconda ivar

#Install mafft

#conda install -y -c bioconda mafft

#Install iqtree

#conda install -y -c bioconda iqtree

#Install figtree

#conda install -y -c bioconda figtree


# Dir containing porechoped .fq reads



fastqDir=../data/run2/fastq_pass/barcode*/*.fastq.gz

refFiles=../data/run1/reference/*.fasta

outputDir=../results/run2

for refFile in $refFiles

do

refFilename=$(basename -s '.fasta' $refFile)
mkdir -p ${outputDir}/$refFilename/{minimap2_sam,samtools_bam,samtools_bai,bcftools_vcf,bcftools_consensus,ivar_consensus,medaka,mafft_aln,iqtree}

# Index the reference sequence

minimap2 -x map-ont -d ${refFilename}.idx $refFile

porechop_files=${fastqDir}/*.fastq

for porechop_fastq_file in $porechop_files

do

readsFilename=$(basename -s '.fastq' $porechop_fastq_file)

   # run alignment with minimap2

    minimap2 -ax map-ont ${refFilename}.idx $porechop_fastq_file > ${outputDir}/$refFilename/minimap2_sam/${readsFilename}.sam

    # run samtools(view: convert sam to bam file, sort: sort bam file, index: index the sorted bam file )

    samtools view -bh ${outputDir}/$refFilename/minimap2_sam/${readsFilename}.sam | samtools sort > ${outputDir}/$refFilename/samtools_bam/${readsFilename}_sorted.bam
    samtools index -b ${outputDir}/$refFilename/samtools_bam/${readsFilename}_sorted.bam ${outputDir}/$refFilename/samtools_bam/${readsFilename}_sorted_bam.bai

    # run bcftools

    # Pilingup reads at each position and calling the variants

    #bcftools mpileup -Ou -f $refFile ${outputDir}/$refFilename/samtools_bam/${readsFilename}_sorted.bam |bcftools call -mv -Oz -o ${outputDir}/$refFilename/bcftools_vcf/${readsFilename}.vcf.gz

    # Indexing the vcf

    #bcftools index ${outputDir}/$refFilename/bcftools_vcf/${readsFilename}.vcf.gz

    # Generating the concesus file

   #bcftools consensus -f $refFile ${outputDir}/$refFilename/bcftools_vcf/${readsFilename}.vcf.gz > ${outputDir}/$refFilename/bcftools_consensus/${readsFilename}.fa

    # Run ivar

    # Pilingup reads at each position and generate the consensus file

    samtools mpileup -A -d 1000 -Q 0 ${outputDir}/$refFilename/samtools_bam/${readsFilename}_sorted.bam | ivar consensus -m 23 -p ${outputDir}/$refFilename/ivar_consensus/$readsFilename

    # # Calling consensus
    #medaka_consensus -i $porechop_fastq_file  -d $consensusFasta -o $barcodeDir 

    # #Running quast   
    # quast -r $refSeq -o $barcordeDir $

    # # Generating report
    # multiqc  --title 'RSVB Assembly Report' --filename 'RSVB_assemlby_report.html'  $quastOuptDir

    #Polishing assembly with medaka
    #medaka_consensus -i $porechop_fastq_file  -d ${outputDir}/$refFilename/ivar_consensus/${readsFilename}.fa -o ${outputDir}/$refFilename/medaka/$readsFilename

done 
done
  
 for refFile in $refFiles

 do

 refFilename=$(basename -s '.fasta' $refFile)
 mkdir -p ${outputDir}/$refFilename/{mafft_aln,iqtree}

# #echo 'Conducting alignment with mafft'

cat ${outputDir}/$refFilename/ivar_consensus/*.fa > ${outputDir}/$refFilename/mafft_aln/${refFilename}_concat.fa

# echo 'beginning alignment with mafft'

 mafft --auto ${outputDir}/$refFilename/mafft_aln/${refFilename}_concat.fa >  ${outputDir}/$refFilename/mafft_aln/${refFilename}_aligned.fa
 
# echo 'mafft analysis complete' 

 done

# # echo 'Generating maximum likelihood tree with iqtree'

# # iqtree -s ${outputDir}/NA/mafft_aln/NA_edit.fa -m MFP -B 1000 --prefix ${outputDir}/NA/iqtree/NA
 
# # echo 'iqtree analysis complete' 

