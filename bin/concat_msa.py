#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse

from Bio import AlignIO


def concat_msa(msas, output):
    """concatenate msas together"""
    alignments = []
    for msa in msas:
        align = AlignIO.read(msa, "fasta")
        # shorten id so the concatenated alignment keeps it
        for record in align._records:
            record.id = record.id.split("|")[0]
        
        if len(align._records) == 3:
            alignments.append(align)
    
    concatenated_alignment = alignments[0]
    for alignment in alignments[1:]:
        concatenated_alignment += alignment
    
    with open(output, "w") as outfile:
        AlignIO.write(concatenated_alignment, outfile, "fasta")


def main():
    parser = argparse.ArgumentParser(
        prog="concat_msa.py"
    )
    parser.add_argument(
        "--msa",
        type=str,
        required=True,
        nargs="*",
        help="multiple sequence alignment to concatenate"
    )
    parser.add_argument(
        "--output",
        type=str,
        required=True,
        help="output file"
    )
    args = parser.parse_args()
    concat_msa(args.msa, args.output)

if __name__ == "__main__":
    main()