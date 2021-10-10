# arbetsprov

## Pipeline Overview

The pipeline is intended for the investigation of unknown bacterial pathogens.

Given short reads, long reads or a mixture of both the pipeline performs QC, assembly, taxonomy asignment, MLST typing  as well as plasmid and antibiotic resistance detection.

The pipeline run the following steps and tools:

- [Fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) for read QC
- [fastp](https://github.com/OpenGene/fastp) for short read filtering and trimming

- [SPADes](https://cab.spbu.ru/software/spades/) for both hybrid and short read assembly
- [Quast](http://quast.sourceforge.net/docs/manual.html) for assembly QC
- [MultiQC](https://multiqc.info/) for aggregating read and assembly QC metrics

- [prodigal](https://github.com/hyattpd/Prodigal) for protein coding gene prediction
- [mmseqs2](https://github.com/soedinglab/MMseqs2) for taxonomic classification
- [cd-hit](http://weizhong-lab.ucsd.edu/cd-hit/) for protein clustering
- [mafft](https://mafft.cbrc.jp/alignment/software/) for multiple sequence alignment
- [fasttree](http://www.microbesonline.org/fasttree/) for phylogenetic analysis

- [mlst_check](https://github.com/sanger-pathogens/mlst_check) for multilocous sequence typing
- [abricate](https://github.com/tseemann/abricate) for antibiotic resistance screening
- [platon](https://www.uni-giessen.de/fbz/fb08/Inst/bioinformatik/software/platon) for plasmid detection

## Usage

Firstly download the required dataset and put it in a `data/` directory as follow:

```
data/
    Iontorrent_Data/IonTorrent.fastq.gz
    Nanopore_Data/Nanopore.fastq.gz
```

then you can run the pipeline with

```bash
make run
```

Alternatively, manually specify inputs:

```bash
nextflow run main.nf -profile docker \
    --ion path_to_ion_data --nanopore path_to_nanopore_data
```

## Output

The pipeline output can be found in the `results/`directory by default.
The output directory contains the following files:

- `report.html`: html presentation summarising the overall results of the pipeline
- `IonTorrent.contigs.fasta`and `hybrid.contigs.fasta`: the short reads and hybrid assemblies, respectively
- `multiqc_report.html`: report summarising the reads and assembly QC and metrics
- `quast_results/`: detailed information about the assemblies
- `mlst_results.allele.csv`: results from `mlst_check`
- `phylo.tree`: phylogenetic tree of sequenced genome and related genomes of the same species
- `hybrid.resistance.txt`: abricate report for antibiotic resistance genes
- `hybrid.contigs.tsv`: platon report for plasmid detection

## Installation and Prerequisites

Only [Nextflow](https://nextflow.io/) and [Docker](https://www.docker.com/) need to be installed

## License

Code is under the [MIT](LICENSE) license.