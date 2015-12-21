#!/usr/bin/python
# -*- coding: utf-8 -*-
from Bio import SeqIO

def analyse_file( inputfile ):
    """
    Take a fasta file and detect if it contain DNA or Protein
    """
    DNA_Alphabet = "atgcn"
    GAP ="_- ?"

    protein = False
    nucleotid = False
    input_handle = open(inputfile, "rU")
    
    for rec in SeqIO.parse(input_handle, "fasta"):
        
        n = 0
        for letter in rec.seq.lower():
            if letter in GAP:
                pass
            else:
                if not letter in DNA_Alphabet:
                    protein =  True
                    break
                
                #reduce time threshold
                #The probability of observing a protein sequence containing
                #only DNA Alphabet in the first twenty residues is almost null
                n += 1
                if n > 20:
                    nucleotid = True
                    break

    typeofseq = "dna"
    
    if protein and nucleotid:
        print "warning ! we detect two types of sequences"
    
    elif protein:
        typeofseq = "protein"

    return typeofseq

if __name__ == "__main__":
    
    import argparse
    
    parser = argparse.ArgumentParser()
    parser.add_argument('file', nargs='?', type=str, action="store", default="", help="input fasta file")
    args = parser.parse_args()
    
    print "%s"%(analyse_file(args.file))
    
    