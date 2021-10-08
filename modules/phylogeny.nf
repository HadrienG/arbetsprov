process cd_hit {
    label "cd_hit"
    input:
        tuple val(prefix), path(proteins), path(related_proteomes)
    output:
        tuple val(prefix), path("${prefix}.clustered.faa")
    script:
        """
        # first concatenate inputs
        gzip -d "${proteins}"
        for f in ${related_proteomes}
        do
            gzip -d "\${f}"
        done
        cat *.faa > cdhit_proteins.faa
        # then run cd-hit
        cd-hit -i cdhit_proteins.faa -o "${prefix}.clustered.faa" \
            -d 0 -d 0.95 -n 5 -T 6
        """
}