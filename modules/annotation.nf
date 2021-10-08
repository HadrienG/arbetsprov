process prodigal {
    tag "annotation: ${prefix}"
    label "prodigal"
    input:
        tuple val(prefix), path(assembly)
    output:
        tuple val(prefix), path("${prefix}.faa.gz"), emit: proteins
        tuple val(prefix), path("${prefix}.gff.gz"), emit: annotations
    script:
        """
        prodigal -a "${prefix}.faa" -f gff -m \
            -i "${assembly}" -o "${prefix}.gff"
        gzip ${prefix}.{faa,gff}
        """
}