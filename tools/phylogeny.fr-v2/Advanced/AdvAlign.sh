#!/bin/bash

# This a shell wrapper to integrate AdvAlign into Galaxy
#
# Author: C. Vernette, V. Lefort
# Date: June 2014
# Version: 1.0
#

DEBUG=1

while getopts a:i:o: option
do
	case $option in
	a)
		choice1=$OPTARG
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

##if user choose MAFFT program##

if [[ $choice1 == "mafftIter" ]]
then	BINARY="$DIR/mafft"
	CMD="$BINARY --bl 62 --quiet --retree 1 --maxiterate 0 --nofft --parttree --ep 0.123 --op 1.53 $input > $output"

elif [[ $choice1 == "mafftLocalpair" ]]
then	BINARY="$DIR/mafft"
	CMD="$BINARY --bl 62 --quiet --localpair --maxiterate 1000 --ep 0.123 --op 1.53 $input > $output"

##if user choose Clustal omega program##

elif [[ $choice1 == "clustalo" ]]
then	BINARY="$DIR/clustalo"
	CMD="$BINARY -i $input -o $output --threads=1 --force --outfmt=fa"
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

