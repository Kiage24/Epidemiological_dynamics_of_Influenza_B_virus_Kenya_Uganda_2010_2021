#!/usr/bin/bash

#Install canu de novo assembler



# # Install seqkit to convert .fastq to fasta

# conda install -y -c bioconda seqkit
 
#  mkdir -p ../results/barcode31/{fasta}

# #Convert the sequence into a fasta file

# seqkit fq2fa ../results/porechop/trimmed/porechop_trimmed/barcode31/concatenated/barcode31.fastq -o ../results/barcode31/fasta/barcode31.fa

#  -o ${outputDir}/seqkitFiles_fasta/${readsFilename}.fa

# fastqDir=../results/porechop/trimmed/porechop_trimmed/barcode*/concatenated 

# refFiles=../data/run1/reference/*.fasta

# outputDir=../results

# for refFile in $refFiles

# do

# refFilename=$(basename -s '.fasta' $refFile)
# mkdir -p ${outputDir}/$refFilename/{minimap2_sam,samtools_bam,samtools_bai,bcftools_vcf,bcftools_consensus,ivar_consensus,mafft_aln,iqtree}

# # Index the reference sequence

# #minimap2 -x map-ont -d ${refFilename}.idx $refFile

# porechop_files=${fastqDir}/*.fastq

# for porechop_fastq_file in $porechop_files

# do

# readsFilename=$(basename -s '.fastq' $porechop_fastq_file)

#    # run alignment with minimap2

#     #minimap2 -ax map-ont ${refFilename}.idx $porechop_fastq_file > ${outputDir}/$refFilename/minimap2_sam/${readsFilename}.sam

#     # run samtools(view: convert sam to bam file, sort: sort bam file, index: index the sorted bam file )

#     #samtools view -bh ${outputDir}/$refFilename/minimap2_sam/${readsFilename}.sam | samtools sort > ${outputDir}/$refFilename/samtools_bam/${readsFilename}_sorted.bam
#     #samtools index -b ${outputDir}/$refFilename/samtools_bam/${readsFilename}_sorted.bam ${outputDir}/$refFilename/samtools_bam/${readsFilename}_sorted_bam.bai

#     # run bcftools

#     # Pilingup reads at each position and calling the variants

#     #bcftools mpileup -Ou -f $refFile ${outputDir}/$refFilename/samtools_bam/${readsFilename}_sorted.bam |bcftools call -mv -Oz -o ${outputDir}/$refFilename/bcftools_vcf/${readsFilename}.vcf.gz

#     # Indexing the vcf

#     #bcftools index ${outputDir}/$refFilename/bcftools_vcf/${readsFilename}.vcf.gz

#     # Generating the concesus file

#    #bcftools consensus -f $refFile ${outputDir}/$refFilename/bcftools_vcf/${readsFilename}.vcf.gz > ${outputDir}/$refFilename/bcftools_consensus/${readsFilename}.fa

#     # Run ivar

#     # Pilingup reads at each position and generate the consensus file

#     #samtools mpileup -A -d 1000 -Q 0 ${outputDir}/$refFilename/samtools_bam/${readsFilename}_sorted.bam | ivar consensus -m 23 -p ${outputDir}/$refFilename/ivar_consensus/$readsFilename


# done 
# done
  
# for refFile in $refFiles

# do

# refFilename=$(basename -s '.fasta' $refFile)
# mkdir -p ${outputDir}/$refFilename/{mafft_aln,iqtree}

# #echo 'Conducting alignment with mafft'

# #cat ${outputDir}/$refFilename/ivar_consensus/*.fa > ${outputDir}/$refFilename/mafft_aln/${refFilename}_concat.fa

# echo 'beginning alignment with mafft'

# #mafft --auto ${outputDir}/$refFilename/mafft_aln/${refFilename}_concat.fa >  ${outputDir}/$refFilename/mafft_aln/${refFilename}_aln.fa
 
# echo 'mafft analysis complete' 


# done

# echo 'Generating maximum likelihood tree with iqtree'

# iqtree -s ${outputDir}/NA/mafft_aln/NA_edit.fa -m MFP -B 1000 --prefix ${outputDir}/NA/iqtree/NA
 
# echo 'iqtree analysis complete' 
