#!/bin/bash

# This a shell wrapper to integrate treeDetect into Galaxy
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

##using FastME if the number sequence is greater than 1500##

if [ $number -ge "1500" ]  
then	BINARY="$DIR"/"fastme"
	CMD="$BINARY -i $input -o $output -n b -g 1 -m I -w b"
	if [ $type == "prot" ]
	then	CMD="$CMD -P L"
	elif [ $type == "nucleo" ]
	then 	CMD="$CMD -D 4"	
	fi

##using PhyML if the sequence number is smaller than 5000##

else 	BINARY="$DIR""/phyml"
	if [ $type == "prot" ]
	then	CMD="$BINARY -d aa -m LG -t e"
	elif [ $type == "nucleo" ]
	then 	CMD="$BINARY -d nt -m HKY85"	
	fi
	CMD="$CMD -i $input -v 0,0 -f e -s NNI -b -4 -c 4 -a e --no_memory_check"	
fi

#---------------------------
#------   DEBUG   ----------
   if [ $DEBUG -eq 1 ]
   then	echo "$CMD"
   fi
#----  END DEBUG   ---------
#---------------------------
eval "$CMD"

if [ $BINARY == "$DIR/phyml" ]
then	tree_suffix=_phyml_tree.txt
	mv ${input}${tree_suffix} ${output}
fi

exit 0

