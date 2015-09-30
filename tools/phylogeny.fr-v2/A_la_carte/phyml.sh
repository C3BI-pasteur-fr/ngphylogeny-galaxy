#!/bin/bash

# This wrapper was initialy created by Southgreen
# to encapsulate PhyML in Galaxy.
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

input_tree=$1
output_tree=$2
output_stat=$3
output_stdout=$4

tree_suffix=_phyml_tree.txt
stat_suffix=_phyml_stats.txt

##if the user selected the bootstrap option##

if [[ $* == *-b\ [1-9]* ]]
then 	output_boot_tree=$5
	output_boot_stat=$6
	boot_tree_suffix=_phyml_boot_trees.txt
	boot_stat_suffix=_phyml_boot_stats.txt
	shift 6
else
	shift 4
fi

DIR=`dirname $0`"/../bin/"
BINARY="$DIR""/phyml"
CMD="$BINARY $* >${output_stdout};"

#---------------------------
#------   DEBUG   ----------
if [ $DEBUG -eq 1 ]
then	echo "$CMD"
fi
#----  END DEBUG   ---------
#---------------------------

eval "$CMD"

mv ${input_tree}${tree_suffix} ${output_tree};
mv ${input_tree}${stat_suffix} ${output_stat};

##if the user selected the bootstrap option##

if [[ $* == *-b\ [1-9]* ]]
then 	mv ${input_tree}${boot_tree_suffix} ${output_boot_tree};
	mv ${input_tree}${boot_stat_suffix} ${output_boot_stat};
fi


exit 0

