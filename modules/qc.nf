process fastqc {
    tag "read qc: ${prefix}"
    label "fastqc"
    input:
        tuple val(prefix), path(reads)
    output:
        path("*_fastqc.{zip,html}")
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
    output:
        tuple val(prefix), path("${prefix}_trimmed.fastq.gz")
    script:
        """
        fastp -w "${task.cpus}" -q 20 -l 50 -3 -5 -M 20 \
            -i "${reads}" -o "${prefix}_trimmed.fastq.gz"
        """
}