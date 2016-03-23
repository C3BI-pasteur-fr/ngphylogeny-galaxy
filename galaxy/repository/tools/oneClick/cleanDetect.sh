#!/bin/bash

# This a shell wrapper to integrate cleanDetect into Galaxy
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

choice=`sed -n "1 p" $input2`
echo $choice
type=`sed -n "2 p" $input2`
number=`sed -n "3 p" $input2`
DIR=`dirname $0`"/../bin/"

##if the user does not choose the cleaning sequence##

if [ $choice == "false" ]
then	CMD="perl $DIR/fastatophylip.pl $input $output phylip"
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

##following information uses such programs or such options##

##using BMGE if the sequence number is greater than 5000##

if [ $number -ge "5000" ]    
then 	BINARY="$DIR/BMGE.jar"
	CMD="java -jar $BINARY -i $input -w 3 -g 0.2 -b 5 -op $output"
	if [ $type == "nucleo" ]
	then	CMD="$CMD -t DNA -m DNAPAM250" 
	elif [ $type == "prot" ]
	then 	CMD="$CMD -t AA -m BLOSUM62"
	fi
	#---------------------------
	#------   DEBUG   ----------
	  if [ $DEBUG -eq 1 ]
	  then	echo "$CMD"
	  fi
	#----  END DEBUG   ---------
	#---------------------------
	eval "$CMD"
	exit 0

##using Gblocks if the sequence number is smaller than 5000##

else	BINARY="$DIR/Gblocks"
	CMD="$BINARY $input -b1=$((number * 51 / 100 + 1)) -b2=$((number * 85 / 100 + 1)) -b3=8 -b4=10 -b5=n"
	if [ $type == "nucleo" ]
	then 	CMD="$CMD -t=d"
	elif [ $type == "prot" ]
	then	CMD="$CMD -t=p"
	fi
	#---------------------------
	#------   DEBUG   ----------
	  if [ $DEBUG -eq 1 ]
	  then	echo "$CMD"
	  fi
	#----  END DEBUG   ---------
	#---------------------------
	eval "$CMD"
	aln_suffix=-gb
	CMD="perl $DIR/fastatophylip.pl $input$aln_suffix $output phylip"
	eval "$CMD"
fi

exit 0



