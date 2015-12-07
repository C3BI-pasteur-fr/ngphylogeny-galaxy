# -*- coding: utf-8 -*-
#!/usr/bin/env python
import argparse
from Bio import AlignIO, SeqIO
from subprocess import call, Popen




def analyse_file( inputfile ):
    """
    Take a fasta file and detect if it contain DNA or Protein
    """
    DNA_Alphabet = "atgcn"
    GAP ="_- "
    protein = False
    nucleotid = False
    input_handle = open(inputfile, "rU")
    
    for rec in SeqIO.parse(input_handle, "phylip"):
        
        tmp = 0
        for a in rec.seq.lower():
            if a in GAP:
                pass
            else:
                if not a in DNA_Alphabet:
                    protein =  True
                    break
                
                #reduce time  
                tmp += 1
                if tmp > 80:
                    nucleotid = True
                    break

    typeofseq = "DNA"
    
    if protein and nucleotid:
        print "warning ! we detect two types of sequences"
    elif protein:
        typeofseq = "Protein"

    return typeofseq




class PhyMLAnalysis(object):
    """Parameter to launch PhyML
    """
    prog = "phyml"
    def __init__(self, inputfile, *args,**kargs ):
        super(PhyMLAnalysis, self).__init__(*args,**kargs)
        
        #default value
        self.seq_file_name =('-i', inputfile )
        typeofseq = analyse_file( inputfile )
        if 'DNA' in typeofseq:
            self.data_type= ('-d','nt')
            self.model = ('-m','HKY85')
            self.tstv_ratio = ('-t','e')

        else:
            self.data_type= ('-d','aa')
            self.model = ('-m','LG')
            
        self.boostrap = ('-b','-4') 
        self.frequency = ('-f','e')  
        self.nb_subst_cat = ('-c','4')
        self.gamma = ('-a','e')  
        self.prop_invar = ('-v','0,0')   
        self.move = ('-s','NNI')
        self.quiet = ('--quiet','')
        self.interactive =('--no_memory_check','')
        
    def setfast(self, fast):
        
        if fast:
            self.boostrap = ('-b','0')
        else:
            self.boostrap = ('-b','-4')
            
    def setslow(self,slow):
        
        if slow:
            self.boostrap = ('-o','tlr')
            self.boostrap = ('-b','-5')
        else:
            self.boostrap = ('-b','-4')
             
    def set_input(self, inputfile):                  
        self.seq_file_name =('-i', inputfile )

        
    def make_commande_line(self):
        
        
        linecmd = [self.prog]

        for k,v in vars(self).items():
            linecmd.extend(list(v))
                
        return " ".join(filter(None,linecmd))


if __name__ == "__main__":

    
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument('-i', nargs='?', type=str, action="store", default="", help="input fasta file")
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--fast', action='store_true', default="", help="set phyML with more speed options")
    group.add_argument('--slow', action='store_true', default="", help="set phyML with more accurate options")
    group.add_argument('--sms', action='store_true', default="", help="use SMS to optimize phyML parameters")
    args, unknown = parser.parse_known_args()
    
    if args.i:
        phyml = PhyMLAnalysis(args.i)
        my_cmd= ''
            
        if args.sms:
            my_cmd = "bash ~/sms/sms.sh "+" ".join(phyml.data_type)+" -i "+args.i
            print my_cmd
            call(my_cmd, shell=True)
            
        else:
            phyml.setfast(args.fast)
            phyml.setslow(args.slow)
            
            if unknown:
                my_cmd = phyml.prog+" -i "+args.i+" "+" ".join(unknown)
            else:   
                my_cmd = phyml.make_commande_line()
            print my_cmd    
            #Excute phyML
            call(my_cmd, shell=True)
                               
    
    
    
    
    
    
    
