#!/usr/bin/python
# -*- coding: utf-8 -*-
import argparse
import sys


def analyse_file( inputfile ):
    """
    Take a fasta file and detect if it contain "dna" or "protein"
    """
    DNA_Alphabet = "atgcn"
    missing_letters = "_- ?\n\b\t\r"
    nb_gap = 0
    protein = False
    nucleotid = False
    typeofseq = "dna"
    
    with open(inputfile, "rU") as input_handle:
    
        for line in input_handle:
            if not line.startswith('>') and not line.startswith('#'):
                for n, letter in enumerate(line.lower()):
                    if letter in missing_letters:
                        nb_gap +=1 
                    else:
                        if not (letter in DNA_Alphabet):
                            protein =  True
                            break
                        
                        #reduce time threshold
                        #The probability of observing a protein sequence containing
                        #only DNA Alphabet in the first twenty residues is almost null
                        if n > (20 + nb_gap) :
                            nucleotid = True
                            print nb_gap, n
                            break
            else:
                nb_gap=0
    
        if protein and nucleotid:
            sys.stderr.write("Warning ! Two types of sequences detected\n")
            
        elif protein:
            typeofseq = "protein"
            
        elif not protein: #or too small
            typeofseq = "dna"
            
    return typeofseq

if __name__ == "__main__":
       
    parser = argparse.ArgumentParser()
    parser.add_argument('file', nargs='?', type=str, action="store", default="", help="input fasta file")
    args = parser.parse_args()

    print "%s" % (analyse_file(args.file))
