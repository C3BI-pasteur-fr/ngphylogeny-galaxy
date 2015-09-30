#!/bin/bash

# This a shell wrapper to integrate AdvTree into Galaxy
#
# Author: C. Vernette, V. Lefort
# Date: June 2014
# Version: 1.0
#

DEBUG=1

while getopts a:b:c:d:e:i:o: option
do
	case $option in
	a)
		choice=$OPTARG
	;;
	b)
		gamma=$OPTARG
	;;
	c)
		NNI=$OPTARG
	;;
	d)
		SPR=$OPTARG
	;;
	e)
		boostrap=$OPTARG
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
echo $choice
DIR=`dirname $0`"/../bin/"

##if user choose PhyML program##

if [[ $choice == "PhProtSm" || $choice == "PhNucSm" ]]
then	BINARY="$DIR""/phyml"
	if [[ $choice == "PhProtSm" ]]
	then	CMD="$BINARY -d aa -m LG -t e"
	elif [[ $choice == "PhNucSm" ]]
	then 	echo "ok"
		CMD="$BINARY -d nt -m HKY85"	
	fi
	CMD="$CMD -i $input -v 0,0 -f e -s NNI -b -4 --no_memory_check"
	if [[ $gamma == "True" ]]
	then 	CMD="$CMD -c 4 -a e"
	fi
	if [[ $SPR == "True" ]]
	then	CMD="$CMD --rand_start 0 --n_rand_starts 5"
	fi
	if [[ $boostrap == "True" ]]
	then	CMD="$CMD -b 100"
	fi

##if user choose FastME program##

elif [[ $choice == "FaProtBig" || $choice == "FaNucBig" ]]
then	BINARY="$DIR"/"fastme"
	if [[ $choice == "FaProtBig" ]]
	then	CMD="$BINARY -P L"
	elif [[ $choice == "FaNucBig" ]]
	then 	CMD="$BINARY -D 4"	
	fi
	CMD="$CMD -i $input -o $output -m I -w b"
	if [[ $gamma == "True" ]]
	then 	CMD="$CMD -g 1"
	fi
	if [[ $NNI == "True" ]]
	then	CMD="$CMD -n b"
	fi
	if [[ $SPR == "True" ]]
	then	CMD="$CMD -s"
	fi
	if [[ $boostrap == "True" ]]
	then	CMD="$CMD -b 100"
	fi
fi

#---------------------------
#------   DEBUG   ----------
   if [ $DEBUG -eq 1 ]
   then	echo "$CMD"
   fi
#----  END DEBUG   ---------
#---------------------------

eval "$CMD"

if [[ $BINARY == "$DIR/phyml" ]]
then	tree_suffix=_phyml_tree.txt
	mv ${input}${tree_suffix} ${output}
fi


exit 0

