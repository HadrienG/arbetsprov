#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include {fastqc} from "./modules/qc.nf"

workflow {
    Channel
        .fromPath(params.ion)
        .map { file -> tuple(file.simpleName, file) }
        .dump()
        .set{ ion }

    fastqc(ion)
}