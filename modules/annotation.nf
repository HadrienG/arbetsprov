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

process mlst_check {
    tag "mlst: ${prefix}"
    label "mlst_check"
    publishDir "${params.output}/", mode: "copy"
    input:
        tuple val(prefix), path(assembly), val(species)
    output:
        tuple val(prefix), path("mlst_results.allele.csv"), emit: mlst
    script:
        """
        get_sequence_type -s "\$(cat ${species})" "${assembly}"
        """
}


process abricate {
    tag "antiobiotic resistance: ${prefix}"
    label "abricate"
    publishDir "${params.output}/", mode: "copy"
    input:
        tuple val(prefix), path(assembly)
    output:
        tuple val(prefix), path("${prefix}.resistance.txt"), emit: results
    script:
        """
        abricate "${assembly}" > "${prefix}.resistance.txt"
        """
}


process platon_db {
    tag "plasmid detection: db download"
    output:
        path("db"), emit: database
    script:
        """
        wget https://zenodo.org/record/4066768/files/db.tar.gz
        tar -xzf db.tar.gz
        """
}


process platon {
    tag "plasmid detection: ${prefix}"
    label "platon"
    publishDir "${params.output}/", mode: "copy"
    input:
        tuple val(prefix), path(assembly)
        path(database)
    output:
        tuple val(prefix), path("hybrid.contigs.tsv"), emit: results
    script:
        """
        platon --threads "${task.cpus}" --db "${database}" \
            "${assembly}"
        """
}