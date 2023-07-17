// Declare syntax version

nextflow.enable.dsl=2

// pipeline input parameters

params.rawfastqreads = "../data/run4/barcode*"
params.summary_file = "../data/run4/sequencing_summary_FAV34853_02303a84_a979b74d.txt"
params.outdir = "../results/run4"

// Check the quality of the reads from the summary text file using pycoqc

process checkqual {
    publishDir "${params.outdir}/pycoqc", mode:'copy'

    input:
    path summary_file

    output:
    path "pycoQC_output.html"

    script:

    """
    pycoQC -f $summary_file -o pycoQC_output.html

    """
}

// Trim the adapters and barcodes added during sequencing

process adapter_trim {
    publishDir "${params.outdir}/porechop", mode:'copy'
 
    input:
    // expecting -> [ barcode01, [path/to/barcorde01] ]

    tuple(val(barcode), path(rawfastqread))

    output:
    path "${fastqfilename}_trimmed.fastq"

    script:

    fastqfilename = rawfastqread.simpleName
    
    """
    porechop -i $rawfastqread -o "${fastqfilename}_trimmed.fastq"
    """
}

workflow{
    channel
        .fromPath(params.rawfastqreads, type: 'dir', checkIfExists: true)
        .map { [it.name, it ] }
        .set {sequences_fastq }

    channel
      .fromPath(params.summary_file)
      .set {summary_file}

    checkqual(summary_file)
    adapter_trim(sequences_fastq)
    
}