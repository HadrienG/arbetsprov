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