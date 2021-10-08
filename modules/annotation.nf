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


process rename_proteins {
    tag "rename: ${prefix}"
    label "biopython"
    input:
        tuple val(prefix), path(proteins)
    output:
        tuple val(prefix), path("renamed/${prefix}.faa"), emit: proteins
    script:
        """
        mkdir renamed
        rename.py --outdir renamed --faa "${proteins}"
        """
}