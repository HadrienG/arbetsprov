process build_db {
    tag "db"
    label "mmseqs2"
    output:
        path("db/"), emit: database
    script:
        """
        mkdir db
        mmseqs databases UniProtKB/Swiss-Prot db/swissprot tmp
        """
}


process assign_taxonomy {
    tag "${prefix}"
    label "mmseqs2"
    input:
        tuple val(prefix), path(assembly)
        path(db)
    output:
        tuple val(prefix), path("taxonomy_lca.tsv"), emit: lca
    script:
        """
        mmseqs easy-taxonomy "${assembly}" "${db}/swissprot" taxonomy tmp
        """
}


process download_related {
    label "biopython"
    input:
        tuple val(prefix), path(taxonomy)
    output:
        tuple val(prefix), path("GCF*.fasta.gz"), emit: genomes
        tuple val(prefix), path("renamed/GCF*.faa"), emit: proteomes
        tuple val(prefix), path("best_hit.txt"), emit: best_hit
    script:
        """
        mkdir renamed
        download.py --lca "${taxonomy}" > best_hit.txt
        rename.py --outdir renamed --faa *.faa.gz
        """
}