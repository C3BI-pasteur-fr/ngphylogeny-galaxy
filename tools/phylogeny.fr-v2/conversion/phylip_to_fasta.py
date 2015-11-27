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
    inputPhylip = options.input
    outputFasta = options.output
    input_handle = open(inputPhylip, "rU")
    output_handle = open(outputFasta, "w")

    alignments = AlignIO.parse(input_handle, "phylip")
    AlignIO.write(alignments, output_handle, "fasta")

    output_handle.close()
    input_handle.close()

        
if __name__ == "__main__":
    main()
    