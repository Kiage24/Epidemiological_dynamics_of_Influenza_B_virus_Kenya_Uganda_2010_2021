// Declare syntax version

nextflow.enable.dsl=2

// pipeline input parameters

params.rawfastqreads = "../test/barcode*"
params.outdir = "../test"

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

process assembly {
    publishDir "${params.outdir}/canu", mode:'copy'

    input:
    path trimmedfastq

    output:

    path "${barcodeprefix}_assembly/*.fasta"

    script:

    barcodeprefix = trimmedfastq.simpleName
     
    """
    canu -p $barcodeprefix -d "${barcodeprefix}_assembly" genomeSize=3k -nanopore $trimmedfastq 
    
    """
}



workflow{
    channel
        .fromPath(params.rawfastqreads, type: 'dir', checkIfExists: true)
        .map { [it.name, it ] }
        .set {sequences_fastq }
    adapter_trim(sequences_fastq)
    assembly(adapter_trim.out)
    assembly.out.view()
    
}