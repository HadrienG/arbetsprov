#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include {hello_world} from "./modules/hello.nf"

workflow {
    hello_world("hello world!")
}