# -*- coding: utf-8 -*-
#!/usr/bin/env python
from Bio import AlignIO

from optparse import OptionParser


# main
def main():
    # define options
    parser = OptionParser()
    parser.add_option("-i", "--input")
    parser.add_option("-o", "--output")

    # parse
    options, args = parser.parse_args()

    # retrieve options
    inputFasta = options.input
    outputPhylip = options.output
    input_handle = open(inputFasta, "rU")
    output_handle = open(outputPhylip, "w")

    alignments = AlignIO.parse(input_handle, "fasta")
    AlignIO.write(alignments, output_handle, "phylip")

    output_handle.close()
    input_handle.close()

        
if __name__ == "__main__":
    main()
    