# -*- coding: utf-8 -*-
# !/usr/bin/env python
"""fasta_to_phylip.py: Convert Fasta to Phylip Relaxed format, use biopython if it's possible."""

__version__ = '1'

from optparse import OptionParser

BIOPYTHON_INSTALLED = True

try:
    from Bio import AlignIO
except ImportError:
    BIOPYTHON_INSTALLED = False


def fasta_to_phylipE(fasta_input, phylip_output, sequential=False):
    """Convert fasta file to phylip relaxed format with biopython library
    """
    input_handle = open(fasta_input, "rU")
    output_handle = open(phylip_output, "w")

    alignments = AlignIO.parse(input_handle, "fasta")

    if sequential:
        AlignIO.write(alignments, output_handle, "phylip-sequential")
    else:
        AlignIO.write(alignments, output_handle, "phylip-relaxed")

    output_handle.close()
    input_handle.close()


class Sequence(object):
    """
        Sequence
    """

    def __init__(self, name, seq):
        self.name = name
        self.seq = seq


def fasta_parse(path):
    """
    Reads the file and yields Sequence objects
    """

    name = ''
    seq = ''
    with open(path) as fasta:
        for line in fasta:
            if line.startswith('>'):
                if seq:
                    yield Sequence(name, seq)
                name = line.rstrip('\n').lstrip('>')
                seq = ""
            else:
                seq += line.rstrip('\n').replace(" ","")

        yield Sequence(name, seq)


class Alignment(object):
    """ Take a list of Sequence objects build Alignment object     
    """

    def __init__(self, sequences):
        self.seqs_length = 0
        self.max_name_length = 64  # relaxed
        self.name_length = 0
        self.sequences = []
        for obj in sequences:
            self.add_sequence(obj)

    def __len__(self):
        return len(self.sequences)

    def add_sequence(self, Sequence):

        self.sequences.append(Sequence)
        self.name_length = min(max(self.name_length, len(Sequence.name) + 1), self.max_name_length)

        if self.seqs_length == 0:
            self.seqs_length = len(Sequence.seq)

        elif self.seqs_length != len(Sequence.seq):
            print self.seqs_length, len(Sequence.seq)
            raise ValueError('Sequences must all be the same length')

    def write_phylip_relaxed_sequencial(self, path):
        """ write Phylip-relaxed format into path file"""

        with open(path, "w") as f:
            f.write("%s %s\n" % (len(self), self.seqs_length))

            for seq in self.sequences:
                seq_name = seq.name[:self.name_length].replace(' ', '_')
                seq_name = seq_name.ljust(self.name_length)

                f.write(seq_name)
                f.write("%s" % seq.seq)
                f.write("\n")

    def write_phylip_relaxed_interleave(self, path):

        wrap_length = self.name_length - 80
        nb_chunk = 0

        with open(path, "w") as f:
            f.write("%s %s\n" % (len(self), self.seqs_length))

            while (nb_chunk * wrap_length) < self.seqs_length:
                for seq in self.sequences:

                    if nb_chunk == 0:

                        seq_name = seq.name[:self.name_length].replace(' ', '_') #cut too long name
                        seq_name = seq_name.ljust(self.name_length) #extend too short name

                    else:
                        seq_name = "".ljust(self.name_length)

                    chunk_seq = seq.seq[nb_chunk*wrap_length: wrap_length]
                    f.write(seq_name)
                    f.write("%s" % chunk_seq)
                    f.write("\n")

                f.write("\n")
                nb_chunk += 1


if __name__ == "__main__":

    # define option
    parser = OptionParser()
    parser.add_option("-i", "--input")
    parser.add_option("-o", "--output")
    parser.add_option("--sequencial", action='store_true')
    parser.add_option("--interleave", action='store_true')
    # parse
    options, args = parser.parse_args()

    if BIOPYTHON_INSTALLED:
        fasta_to_phylipE(options.input, options.output, options.sequencial)

    else:
        algn = Alignment(fasta_parse(options.input))

        if options.sequencial:
            algn.write_phylip_relaxed_sequencial(options.output)
        else:
            algn.write_phylip_relaxed_interleave(options.output)
