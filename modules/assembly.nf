process unicycler {
    tag "assembly: ${prefix}"
    label "unicycler"
    input:
        tuple val(prefix), path(reads)
    output:
        tuple val(prefix), path("assembly/assembly.fasta"), emit: contigs
    script:
        """
        unicycler -t "${task.cpus}" -s "${reads}" -o assembly
        """

}


process spades {
    tag "assembly: ${prefix}"
    label "spades"
    publishDir "${params.output}/", mode: "copy"
    input:
        tuple val(prefix), path(reads)
    output:
        tuple val(prefix), path("${prefix}.contigs.fasta"), emit: contigs
    script:
        def mem = "${task.memory.toString().replaceAll(/[\sGB]/,'')}"
        """
        spades.py --threads "${task.cpus}" -m "${mem}" \
            -k 27,47,77,107,127 -s "${reads}" -o assembly
        mv assembly/scaffolds.fasta "${prefix}.contigs.fasta"
        """
}


process spades_hybrid {
    tag "assembly: hybrid"
    label "spades"
    publishDir "${params.output}/", mode: "copy"
    input:
        tuple val(_0), path(reads)
        tuple val(_1), path(long_reads)
    output:
        tuple val("hybrid"), path("assembly/scaffolds.fasta"), emit: contigs
    script:
        def mem = "${task.memory.toString().replaceAll(/[\sGB]/,'')}"
        """
        spades.py --threads "${task.cpus}" -m "${mem}" \
            -k 27,47,77,107,127 -s "${reads}" --nanopore "${long_reads}" \
            -o assembly
        """
}