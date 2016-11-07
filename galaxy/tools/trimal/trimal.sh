#!/bin/bash

# This wrapper was initialy created by Southgreen
# to encapsulate trimAL in Galaxy.
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

DIR=`dirname $0`"/../bin/"
BINARY="$DIR""/trimal"
CMD="$BINARY $* -phylip"

#---------------------------
#------   DEBUG   ----------
if [ $DEBUG -eq 1 ]
then	echo "$CMD"
fi
#----  END DEBUG   ---------
#---------------------------

eval "$CMD"

exit 0

