# arbetsprov

## Pipeline Overview

The pipeline is intended for the investigation of unknown bacterial pathogens.

Given short reads, long reads or a mixture of both the pipeline performs QC, assembly, taxonomy asignment, phylogenetic analysis as well as plasmid and antibiotic resistance detection.

The pipeline use the following tools:

- [Fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) and [fastp](https://github.com/OpenGene/fastp) for short read quality control
- [MultiQC](https://multiqc.info/) for aggregating read and assembly QC metrics

## Usage

you can launch the pipeline with default input dataset and parameters with 

```bash
make run
```

## Installation and Prerequisites

Only [Nextflow](https://nextflow.io/) and [Docker](https://www.docker.com/) need to be installed

## License

Code is under the [MIT](LICENSE) license.