#!/bin/bash

# This a shell wrapper to integrate align into Galaxy
#
# Author: C. Vernette, V. Lefort
# Date: April 2014
# Version: 1.0
#

DEBUG=1

while getopts a:b:c:d:e:f:g:i:j:k:o: option
do
	case $option in
	a)
		binaire=$OPTARG
	;;
	b)
		clus=$OPTARG
		dealign=`echo $clus | cut -d " " -f 1`
		clusteringGuideTree=`echo $clus | cut -d " " -f 2`
		clusteringIteration=`echo $clus | cut -d " " -f 3`
		nbrIter=`echo $clus | cut -d " " -f 4`
		maxGuideTreeIteration=`echo $clus | cut -d " " -f 5`
		maxHmmIterations=`echo $clus | cut -d " " -f 6`
	;;
	c)
		iterations=$OPTARG
	;;
	d)
		datatype=$OPTARG
		type=`echo $datatype | cut -d " " -f 1`
		matrix=`echo $datatype | cut -d " " -f 2`
	;;
	e)
		PAM_value=$OPTARG
	;;		
	f)
		choice=$OPTARG
	;;
	g)
		alignmentM=$OPTARG
	;;
	j)
		ep=$OPTARG
	;;
	k)
		other=$OPTARG
		op=`echo $other | cut -d " " -f 1`
		distance_method=`echo $other | cut -d " " -f 2`
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

if [[ $binaire == "clustalO" ]]
then 	BINARY="$DIR""/clustalo"
	CMD="$BINARY -i $input $dealign $clusteringGuideTree $clusteringIteration $nbrIter $maxGuideTreeIteration $maxHmmIterations -o $output --threads=1 --force --outfmt=fa"
fi

if [[ $binaire == "muscle" ]]
then 	BINARY="$DIR""/muscle" 
	CMD="$BINARY -in $input -out $output -quiet -maxiters $iterations"
fi

if [[ $binaire == "mafft" ]]
then 	BINARY="$DIR""/mafft"
	CMD="$BINARY --treeout --quiet $alignmentM --ep $ep"
	if [[ $type == "nt" ]] 
 	then	CMD="$CMD --nuc"
	fi
	if [[ $type == "aa" ]] 
 	then	CMD="$CMD --amino"
	fi
	if [[ $matrix != "PAM" ]]
	then	CMD="$CMD --bl $matrix"
	else 	CMD="$CMD --jtt $PAM_value"
	fi 
       	CMD="$CMD --$distance_method --op $op $input > $output"
fi

#---------------------------
#------   DEBUG   ----------
   if [ $DEBUG -eq 1 ]
   then	 echo "$CMD"
   fi
#----  END DEBUG   ---------
#---------------------------

eval "$CMD"

exit 0

