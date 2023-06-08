q// Declare syntax version

nextflow.enable.dsl=2

// pipeline input parameters

params.fastqreads = "../results/porechop/trimmed/porechop_trimmed/barcode*/concatenated/*.fastq"
params.refgenome = "../data/run1/reference/*.fasta"
params.outdir = "../nextflow_results/"


// indexes the fasta reference file and maps fastq reads to reference

process maptoref{
    publishDir "${params.outdir}/minimap", mode:'copy'

    input:
    path sequence_fastq
    each path(reference_fasta)


    output:
    path "${indexed_ref_fasta}_${barcorde_name}.sam"

    script:

    indexed_ref_fasta = reference_fasta.simpleName
    barcorde_name = sequence_fastq.simpleName

    """
    minimap2 -x map-ont -d "${indexed_ref_fasta}.idx" $reference_fasta  
    minimap2 -ax map-ont "${indexed_ref_fasta}.idx" $sequence_fastq > "${indexed_ref_fasta}_${barcorde_name}.sam" 
    """

    }

    // Run samtools(view: convert sam to compressed bam file, sort: sort bam files to make the alignments be in genome order, index: index the sorted bam file to efficiently locate overlapping alignments in genomic regions )


    process sortidx{
        publishDir "${params.outdir}/samtools", mode:'copy'

        input:
        path mapped_sam

        output:
        path "${sorted_barcode_name}_sorted.bam"

        script:

        sorted_barcode_name = mapped_sam.simpleName 

        """
        samtools view -S -bh $mapped_sam | samtools sort > "${sorted_barcode_name}_sorted.bam"
        samtools index -b "${sorted_barcode_name}_sorted.bam"
        """

    }

    process consensus{
        publishDir "${params.outdir}/ivar/HA",  pattern: "HA*" , mode:'copy'
        publishDir "${params.outdir}/ivar/NA",  pattern: "NA*" , mode:'copy'
        publishDir "${params.outdir}/ivar/PA",  pattern: "PA*" , mode:'copy'
        publishDir "${params.outdir}/ivar/PB1",  pattern: "PB1*" , mode:'copy'
        publishDir "${params.outdir}/ivar/PB2",  pattern: "PB2*" , mode:'copy'
        publishDir "${params.outdir}/ivar/M1",  pattern: "M1*" , mode:'copy'
        publishDir "${params.outdir}/ivar/NS1",  pattern: "NS1*" , mode:'copy'
        publishDir "${params.outdir}/ivar/NP",  pattern: "NP*" , mode:'copy'

        input:

        path sorted_bam

        output:

        path "*.fa"


        script:

        mpiled_barcode_name = sorted_bam.simpleName 

        """
        samtools mpileup -A -d 1000 -Q 0 $sorted_bam | ivar consensus -m 23 -p $mpiled_barcode_name

        """

    }


     workflow{
        sequences_fastq = Channel.fromPath(params.fastqreads)
        references_fasta = Channel.fromPath(params.refgenome)
        
        maptoref(sequences_fastq ,references_fasta)
        sortidx(maptoref.out)
        consensus(sortidx.out)

        
}


