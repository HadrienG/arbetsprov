#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import gzip
import argparse


def is_gzipped(infile):
    """Check in a file is in gzip format or not
    """
    magic_number = b"\x1f\x8b"
    with open(infile, "rb") as f:
        try:
            assert f.read(2) == magic_number
        except AssertionError as e:
            return False
        else:
            return True


def rename(faa, outdir):
    prefix = os.path.basename(faa).split(".")[0]
    if is_gzipped(faa):
        f = gzip.open(faa, "rt")  # "rt" forces text mode even on gzipped files
    else:
        f = open(faa, "r")
    with f, open(f"{outdir}/{prefix}.faa", "w") as outfile:
        for line in f:
            if line.startswith(">"):
                suffix = line.split(" ")[0][1:]
                new_line = f">{prefix}|{suffix}\n"
                outfile.write(new_line)
            else:
                outfile.write(line)
    f.close()


def main():
    parser = argparse.ArgumentParser(
        prog="rename.py"
    )
    parser.add_argument(
        "--faa",
        type=str,
        required=True,
        nargs="*",
        help="faa file(s) whose sequences will be renamed"
    )
    parser.add_argument(
        "--outdir",
        type=str,
        required=True,
        help="output_directory"
    )
    args = parser.parse_args()
    for faa in args.faa:
        rename(faa, args.outdir)


if __name__ == "__main__":
    main()