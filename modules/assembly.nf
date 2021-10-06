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
    input:
        tuple val(prefix), path(reads)
    output:
        tuple val(prefix), path("assembly/scaffolds.fasta"), emit: contigs
    script:
        def mem = "${task.memory.toString().replaceAll(/[\sGB]/,'')}"
        """
        spades.py --threads "${task.cpus}" -m "${mem}" \
            -k 27,47,77,107,127 -s "${reads}" -o assembly
        """
}