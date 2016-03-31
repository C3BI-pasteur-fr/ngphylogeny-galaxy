# -*- coding: utf-8 -*-
#!/usr/bin/env python
from Bio import AlignIO
from optparse import OptionParser

def fasta_to_phylipE(fasta_input, phylip_output):
    """Convert fasta file to phylip relaxed format with biopython library
    """
    input_handle = open(fasta_input, "rU")
    output_handle = open(phylip_output, "w")

    alignments = AlignIO.parse(input_handle, "fasta")
    AlignIO.write(alignments, output_handle, "phylip-relaxed")

    output_handle.close()
    input_handle.close()

if __name__ == "__main__":
    
    # define option
    parser = OptionParser()
    parser.add_option("-i", "--input")
    parser.add_option("-o", "--output")

    # parse
    options, args = parser.parse_args()
    fasta_to_phylipE(options.input, options.output)