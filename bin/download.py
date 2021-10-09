#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging
import argparse

import requests

from Bio import Entrez

Entrez.tool = "arbetsprov"
Entrez.email = ""

class Assembly(object):
    """object representation of an assembly"""
    def __init__(self, entrez_dict):
        super(Assembly, self).__init__()
        self._all = entrez_dict
        self.organism = entrez_dict["Organism"]
        self.species_name = entrez_dict["SpeciesName"]

        self.taxid = entrez_dict["Taxid"]
        self.species_taxid = entrez_dict["SpeciesTaxid"]

        self.accession = entrez_dict["AssemblyAccession"]
        self.versioned_accession = entrez_dict["LastMajorReleaseAccession"]

        self.status = entrez_dict["AssemblyStatus"]
        self.name = entrez_dict["AssemblyName"]

        self.ftp_refseq = entrez_dict["FtpPath_RefSeq"]
        self.ftp_genbank = entrez_dict["FtpPath_GenBank"]


def query_assemblies(organism):
    """from a taxid or a organism name, download reference genomes
    """
    logger = logging.getLogger(__name__)

    assemblies = []

    genomes = Entrez.read(Entrez.esearch(
        "assembly",
        term=f"{organism}[Organism] AND \"reference genome\"[filter]",
        retmax=10000))["IdList"]

    logger.info(
        f"Found {len(genomes)} organisms in ncbi assemblies for {organism}")
    logger.info(
        "Downloading the assemblies and associated proteins. Please wait.")
    for id in genomes:
        try:
            entrez_assembly = Entrez.read(
                Entrez.esummary(
                    db="assembly",
                    id=id),
                    validate=False)["DocumentSummarySet"]["DocumentSummary"][0]
        except KeyError as e:
            entrez_assembly = Entrez.read(
                Entrez.esummary(db="assembly", id=id))["DocumentSummarySet"]
            print(entrez_assembly.keys())
            raise
        else:
            a = Assembly(entrez_assembly)
            output_assembly = f"{a.accession}.fasta.gz"
            output_proteins = f"{a.accession}.faa.gz"

            url_ass = f"{a.ftp_refseq}/{a.accession}_{a.name}_genomic.fna.gz"
            url_prot = f"{a.ftp_refseq}/{a.accession}_{a.name}_protein.faa.gz"
            download(url_ass, output_assembly)
            download(url_prot, output_proteins)
            assemblies.append(a)

    return assemblies


def parse_taxonomy(lca_file, level="species"):
    """parse lca results from mmseqs2 and return the most common
    hit at `level`
    """
    species = {}
    with open(lca_file, "r") as f:
        for line in f:
            splitted_line = line.rstrip().split("\t")
            if splitted_line[2] == level:
                if splitted_line[3] in species.keys():
                    species[splitted_line[3]] += 1
                else:
                    species[splitted_line[3]] = 1
            else:
                continue
    best_hit = max(species, key = species.get)
    return best_hit


def download(url, output_file, chunk_size=1024):
    """download an url
    """
    if url.startswith("ftp://"):  # requests doesnt support ftp
        url = url.replace("ftp://", "https://")
    if url:
        request = requests.get(url, stream=True)

        with open(output_file, "wb") as f:
            for chunk in request.iter_content(chunk_size=chunk_size):
                if chunk:
                    f.write(chunk)
                    f.flush()


def main():
    parser = argparse.ArgumentParser(
        prog="download.py"
    )
    parser.add_argument(
        "--lca",
        type=str,
        required=True,
        help="lca results from mmseqs2"
    )
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    args = parser.parse_args()
    best_hit = parse_taxonomy(args.lca)
    res = query_assemblies(best_hit)


if __name__ == "__main__":
    main()