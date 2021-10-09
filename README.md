# arbetsprov

## Pipeline Overview

The pipeline is intended for the investigation of unknown bacterial pathogens.

Given short reads, long reads or a mixture of both the pipeline performs QC, assembly, taxonomy asignment, phylogenetic analysis as well as plasmid and antibiotic resistance detection.

The pipeline use the following tools:

- [Fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) and [fastp](https://github.com/OpenGene/fastp) for short read quality control
- [SPADes](https://cab.spbu.ru/software/spades/) for short read assembly
- [MultiQC](https://multiqc.info/) for aggregating read and assembly QC metrics
- [prodigal](https://github.com/hyattpd/Prodigal) for protein coding gene prediction
- [mmseqs2](https://github.com/soedinglab/MMseqs2) for taxonomic classification
- [cd-hit](http://weizhong-lab.ucsd.edu/cd-hit/) for protein clustering
- [mafft](https://mafft.cbrc.jp/alignment/software/) for multiple sequence alignment
- [fasttree](http://www.microbesonline.org/fasttree/) for phylogenetic analysis

## Usage

you can launch the pipeline with default input dataset and parameters with 

```bash
make run
```

## Installation and Prerequisites

Only [Nextflow](https://nextflow.io/) and [Docker](https://www.docker.com/) need to be installed

## License

Code is under the [MIT](LICENSE) license.