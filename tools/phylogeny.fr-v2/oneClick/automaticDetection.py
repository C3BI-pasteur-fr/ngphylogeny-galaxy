#!/usr/bin/python
# -*- coding: utf-8 -*-
import argparse

def analyse_file( inputfile ):
    """
    Take a fasta file and detect if it contain DNA or Protein
    """
    DNA_Alphabet = "atgcn"
    GAP ="_- ?"
    n = 0
    protein = False
    nucleotid = False
    typeofseq = "dna"
    
    with open(inputfile, "rU") as input_handle:
    
        for line in input_handle:
        
            if line.startswith('>') or line.startswith('#'):
                n = 0
            
            else:
                for letter in line.lower():
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
    
    