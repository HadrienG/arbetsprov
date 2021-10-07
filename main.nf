#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include {fastqc; fastp; quast; multiqc} from "./modules/qc.nf"
include {spades} from "./modules/assembly.nf"
include {build_db; assign_taxonomy;
         download_related} from "./modules/taxonomy.nf"

workflow {
    Channel
        .fromPath(params.ion)
        .map { file -> tuple(file.simpleName, file) }
        .dump()
        .set{ ion }

    fastp(ion, params.fastp_trim, params.fastp_filter, params.fastp_len)

    // processes cannot be reused in DSL2
    // We therefore merge both raw and trimmed reads channels
    // to only use the fastqc process once
    Channel
        .fromPath(params.ion)
        .map { file -> tuple(file.simpleName, file) }
        .concat(fastp.out.trimmed_reads)
        .set{fastqc_input}
    fastqc(fastqc_input)

    fastqc.out.all
        .collect()
        .set{fastqc_for_multiqc}

    spades(fastp.out.trimmed_reads)
    quast(spades.out.contigs)
    
    multiqc(fastqc_for_multiqc, quast.out.report)

    build_db()
    assign_taxonomy(spades.out.contigs, build_db.out.database)
    download_related(assign_taxonomy.out.lca)
}