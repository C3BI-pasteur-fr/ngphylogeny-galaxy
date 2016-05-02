#!/bin/bash

# This a shell wrapper to integrate aligndetect into Galaxy
#
# Author: C. Vernette, V. Lefort
# Date: June 2014
# Version: 1.0
#

DEBUG=1

input=$1
input2=$2
output=$3


##recovered data file information##

type=`sed -n "2 p" $input2`
number=`sed -n "3 p" $input2`
DIR=`dirname $0`"/../bin/"


##following information uses such programs or such options##

##using clustal omega if the number sequence is greater than 50000##

if [[ $number -ge "50000" ]]
then 	CMD="$DIR""/clustalo -i $input -o $output --threads=1 --force --outfmt=fa"
	#---------------------------
	#------   DEBUG   ----------
	  if [ $DEBUG -eq 1 ]
	  then	echo "$CMD"
	  fi
	#----  END DEBUG   ---------
	#---------------------------
	eval "$CMD"
	exit 0
fi

##otherwise using mafft##

BINARY="$DIR/mafft"

if [[ $type == "nucleo" ]]
then	CMD="$BINARY --nuc"
fi
if [[ $type == "prot" ]]
then	CMD="$BINARY --amino --bl 62"
fi

if [[ $number -ge "10000" ]]
then 	CMD="$CMD --quiet --retree 1 --maxiterate 0 --nofft --parttree" 
elif [[ $number -ge "2000" ]]
then	CMD="$CMD --quiet --retree 1 --maxiterate 0"
elif [[ $number -ge "100" ]]
then 	CMD="$CMD --quiet --retree 2 --maxiterate 0"
else	CMD="$CMD --quiet --localpair --maxiterate 1000"
fi
CMD="$CMD --ep 0.123 --op 1.53 $input > $output"

#---------------------------
#------   DEBUG   ----------
  if [ $DEBUG -eq 1 ]
  then	echo "$CMD"
  fi
#----  END DEBUG   ---------
#---------------------------

eval "$CMD"

exit 0


