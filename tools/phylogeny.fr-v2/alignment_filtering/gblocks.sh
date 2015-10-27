#!/bin/bash

# This wrapper was initialy created by Southgreen
# to encapsulate GBlocks in Galaxy.
# It was improved by ATGC (C. Vernette, V. Lefort)
#
# Author: Southgreen, C. Vernette, V. Lefort
# Date: April 2014
# Version: 1.1
#


DEBUG=1

#---------------------------
#------   DEBUG   ----------
  if [ $DEBUG -eq 1 ]
  then	echo $*
  fi
#----  END DEBUG   ---------
#---------------------------

input=$1
output_aln=$2
output_htm=$3
ba=$4
bb=$5
aln_suffix=-gb
htm_suffix=-gb.htm
phylip_suffix=.phylip
shift 5
DIR=`dirname $0`"/../bin/"

##to convert sequences and sites percentages into absolute values##

phytmp=`dirname "$output_aln"`/$RANDOM
BINARY="$DIR""gblocksConv.pl"
CMD="perl $BINARY $input $phytmp >/dev/null"

#---------------------------
#------   DEBUG   ----------
   if [ $DEBUG -eq 1 ]
   then	echo "Counts the number of sequences"
 	echo "$CMD"
   fi
#----  END DEBUG   ---------
#---------------------------

eval "$CMD"
nbseq=`head -n 1 "$phytmp" | cut -d " " -f 2` 
if [ -f $phytmp ]
then
	rm $phytmp
fi

#---------------------------
#------   DEBUG   ----------
   if [ $DEBUG -eq 1 ]
   then	echo "Number of sequences: $nbseq"
   fi
#----  END DEBUG   ---------
#---------------------------

##execution of Gblocks##

BINARY="$DIR""Gblocks"
CMD="$BINARY $input -b1=$((nbseq * ba / 100 + 1)) -b2=$((nbseq * bb / 100 + 1)) $*"

#---------------------------
#------   DEBUG   ----------
   if [ $DEBUG -eq 1 ]
   then	echo "Command line"
	echo "$CMD"
   fi
#----  END DEBUG   ---------
#---------------------------

eval "$CMD"

#---------------------------
#------   DEBUG   ----------
   if [ $DEBUG -eq 1 ]
   then	echo "List working directory files"
	ls -l
   fi
#----  END DEBUG   ---------
#---------------------------

mv ${input}${aln_suffix} ${output_aln}
mv ${input}${htm_suffix} ${output_htm}
 
##fasta file converted phylip##

BINARY="$DIR""gblocksConv.pl"
CMD="perl $BINARY $output_aln $output_aln$phylip_suffix >/dev/null"

#---------------------------
#------   DEBUG   ----------
   if [ $DEBUG -eq 1 ]
   then	echo "fasta file converted phylip"
	echo "$CMD"
   fi
#----  END DEBUG   ---------
#---------------------------

eval "$CMD"
mv ${output_aln}${phylip_suffix} ${output_aln}

exit 0

