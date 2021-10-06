process fastqc {
    tag "read qc: ${prefix}"
    label "fastqc"
    input:
        tuple val(prefix), path(reads)
    output:
        path("*_fastqc.{zip,html}"), emit: all
    script:
        """
        fastqc -t "${task.cpus}" ${reads}
        """
    }


process fastp {
    tag "trimming: ${prefix}"
    label "fastp"
    input:
        tuple val(prefix), path(reads)
        val(trim)
        val(filter)
        val(len)
    output:
        tuple val(prefix), path("${prefix}Trimmed.fastq.gz"),
            emit :trimmed_reads
    script:
        """
        fastp -w "${task.cpus}" -q "${filter}" -l "${len}" -3 -5 -M "${trim}" \
            -i "${reads}" -o "${prefix}Trimmed.fastq.gz"
        """
}


process quast {
    tag "assembly qc: ${prefix}"
    label "quast"
    input:
        tuple val(prefix), path(assembly)
    output:
        path("quast_results/"), emit: report
    script:
        """
        quast.py -t "${task.cpus}" -l "${prefix}" "${assembly}"
        """
}


process multiqc {
    label "multiqc"
    input:
        path(fastqc_for_multiqc)
        path(quast_report)
    output:
        path("multiqc_report.html")
    script:
        """
        multiqc .
        """
}