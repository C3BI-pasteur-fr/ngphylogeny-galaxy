# -*- coding: utf-8 -*-
#!/usr/bin/env python

from optparse import OptionParser

def bioPython_test():
    try:
        from Bio import AlignIO
    except ImportError:
        return False
    else:
        return True


def fasta_to_phylipE(fasta_input, phylip_output):
    """Convert fasta file to phylip relaxed format with biopython library
    """
    input_handle = open(fasta_input, "rU")
    output_handle = open(phylip_output, "w")

    alignments = AlignIO.parse(input_handle, "fasta")
    AlignIO.write(alignments, output_handle, "phylip-relaxed")

    output_handle.close()
    input_handle.close()


class Sequence(object):
    """Sequence"""

    def __init__(self, name, seq):
        self.name = name
        self.seq = seq


class PhylipAlgn(object):
    """ Take a liste of Sequence objects build PhylipAlgn objects  """
    def __init__(self, sequences):

        self.seq_length = 0
        self.name_length = 0
        self.sequences = []
        for obj in sequences:
            self.add_sequence(obj)

    def add_sequence(self, Sequence):
        self.sequences.append(Sequence)
        self.seq_length = max(self.seq_length,len(Sequence.seq))
        self.name_length = max(self.name_length,len(Sequence.name))

    def write_phylip_relaxed(self, path):
        """ write Phylip-relaxed format into path file"""

        with open(path, "w") as f:
            f.write("%s %s\n"%(len(self), self.seq_length))

            for seq in self.sequences:
                seq_name = seq.name[:self.name_length].ljust(self.name_length)
                seq_name = seq_name.replace(' ','_')
                f.write(seq_name)    
                f.write(" %s" % seq.seq)
                f.write("\n")

    def __len__(self):
        return len(self.sequences) 


def fasta_parse(path):
    """Reads the file and yields Sequence objects"""

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
                seq += line.rstrip('\n')

        yield Sequence(name, seq)


if __name__ == "__main__":
    
    # define option
    parser = OptionParser()
    parser.add_option("-i", "--input")
    parser.add_option("-o", "--output")

    # parse
    options, args = parser.parse_args()
    
    if bioPython_test():
        fasta_to_phylipE(options.input, options.output)
    else:
        algn = PhylipAlgn(fasta_parse(options.input))
        algn.write_phylip_relaxed(options.output)

    
    
    
    
    
    
    
    