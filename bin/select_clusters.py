#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import itertools

from Bio import SeqIO


class Cluster(object):
    """object representation of a protein cluster"""
    def __init__(self, name, content):
        super(Cluster, self).__init__()
        self.name = name.strip()[1:]
        self._raw = content
        self.parse_content()
        self.mean_length = sum(self.lengths) / self.n

    def parse_content(self):
        self.n = len(self._raw)
        self.lengths = []
        self.proteins = []
        self.genomes_of_origin = []
        for member in self._raw:
            length_and_name = member.split("\t")[1]
            length = int(length_and_name.split(",")[0][:-2])
            prot_id = length_and_name.split(",")[1].strip().split("...")[0][1:]
            genome = prot_id.split("|")[0]
            self.lengths.append(length)
            self.proteins.append(prot_id)
            self.genomes_of_origin.append(genome)



def select_clusters(cluster_file):
    """parse cluster file and return cluster where:
    
        all 3 genomes are represented
        matches are of equal lengths
        matches are over 1000bp"""
    clusters = []
    good_clusters = []
    with open(cluster_file, "r") as f:
        groups = itertools.groupby(f, key=lambda line: line[0] == ">")
        for _, group in groups:
            name = next(group)
            _, content = next(groups)

            cluster = Cluster(name, list(content))
            clusters.append(cluster)

    for cluster in clusters:
        if cluster.n == 3 and \
            cluster.mean_length > 1000 and \
            len(set(cluster.lengths)) == 1 and \
            len(set(cluster.genomes_of_origin)) == 3:
            good_clusters.append(cluster)
    return good_clusters


def clusters_to_faa(clusters, outdir, faa_dir):
    """from a list of cluster Objects, creates
    one multi-fasta file per cluster"""
    for cluster in clusters:
        outfile_name = f"{outdir}/{cluster.name.replace(' ', '_')}.faa"
        outfile = open(outfile_name, "w")
        for i in range(len(cluster.genomes_of_origin)):
            faa = open(f"{faa_dir}/{cluster.genomes_of_origin[i]}.faa")
            faa_file = SeqIO.parse(faa, 'fasta')
            for record in faa_file:
                if record.id.startswith(cluster.proteins[i]):
                    SeqIO.write(record, outfile, "fasta")
            faa.close()

    outfile.close()


def main():
    parser = argparse.ArgumentParser(
        prog="select_clusters.py"
    )
    parser.add_argument(
        "--clstr",
        type=str,
        required=True,
        help=".clstr file from cd-hit"
    )
    parser.add_argument(
        "--outdir",
        type=str,
        required=True,
        help="output_directory"
    )
    parser.add_argument(
        "--faa_dir",
        type=str,
        required=True,
        help="directory containing input faa"
    )
    args = parser.parse_args()
    clusters = select_clusters(args.clstr)
    clusters_to_faa(clusters, args.outdir, args.faa_dir)


if __name__ == "__main__":
    main()