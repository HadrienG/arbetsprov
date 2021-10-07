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
        tuple val(prefix), path("taxonomy_*")
    script:
        """
        mmseqs easy-taxonomy "${assembly}" "${db}/swissprot" taxonomy tmp
        """
}