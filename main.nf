#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include {fastqc; fastp; multiqc} from "./modules/qc.nf"

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
        .set{multiqc_input}
    multiqc(multiqc_input)
}