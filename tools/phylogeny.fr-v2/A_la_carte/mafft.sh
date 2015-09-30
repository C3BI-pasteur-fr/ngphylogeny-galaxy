#!/bin/bash

# This wrapper was initialy created by Southgreen
# to encapsulate PhyML in Galaxy.
# It was improved by ATGC (C. Vernette, V. Lefort)
#
# Author: Southgreen, C. Vernette, V. Lefort
# Date: April 2014
# Version: 1.1
#


DEBUG=0

#---------------------------
#------   DEBUG   ----------
  if [ $DEBUG -eq 1 ]
  then	echo $*
  fi
#----  END DEBUG   ---------
#---------------------------

output_tree=$1
input=$2
tree_suffixe=.tree
tmp_suffixe=.tmp
shift 2

DIR=`dirname $0`"/../bin/"
BINARY="$DIR""/mafft"
CMD="$BINARY --treeout $*"

#---------------------------
#------   DEBUG   ----------
if [ $DEBUG -eq 1 ]
then	echo "$CMD"
fi
#----  END DEBUG   ---------
#---------------------------

eval "$CMD"

sed 's/$/;/g' ${input}${tree_suffixe} > ${output_tree}
rm ${input}${tree_suffixe}

exit 0

