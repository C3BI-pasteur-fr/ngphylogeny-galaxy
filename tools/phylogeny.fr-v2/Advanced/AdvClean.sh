#!/bin/bash

# This a shell wrapper to integrate AdvClean into Galaxy
#
# Author: C. Vernette, V. Lefort
# Date: June 2014
# Version: 1.0
#

DEBUG=1

while getopts a:b:i:o: option
do
	case $option in
	a)
		choice1=$OPTARG
	;;
	b)
		choice2=$OPTARG
	;;
	i)
		input=$OPTARG
	;;
	o)
		output=$OPTARG
	;;
	*)
	;;
	esac
done

DIR=`dirname $0`"/../bin/"

##if user choose Gblocks program##

if [[ $choice1 == "GbStriProt" || $choice1 == "GbStriNuc" ]]
then 	aln_suffix=-gb
	temp="$DIR"/$RANDOM
	BINARY="$DIR/fastatophylip.pl"
	CMD="perl $BINARY $input $temp phylip"
	eval $CMD
	nbseq=`head -n 1 "$temp" | cut -d " " -f 2` 
	rm $temp
	BINARY="$DIR/Gblocks"
	CMD="$BINARY $input -b1=$(($nbseq * 51 / 100 + 1)) -b2=$(($nbseq * 85 / 100 + 1)) -b3=8 -b4=$choice2 -b5=n"
	if [[ $choice1 == "GbStriProt" ]]
	then	CMD="$CMD -t=p"
	elif [[ $choice1 == "GbStriNuc" ]]
	then	CMD="$CMD -t=d"
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

##if user choose BMGE program##

elif [[ $choice1 == "BMBigProt" || $choice1 == "BMBigNuc" ]]
then	BINARY="$DIR/BMGE.jar" 
	CMD="java -jar $BINARY -i $input -w 3 -g 0.2 -b $choice2 -op $output"
	if [ $choice1 == "BMBigNuc" ]
	then	CMD="$CMD -t DNA -m DNAPAM250" 
	elif [ $choice1 == "BMBigProt" ]
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
fi

exit 0

