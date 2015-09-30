#!/bin/bash

# This a shell wrapper to integrate Clustal Omega into Galaxy
#
# Author: C. Vernette, V. Lefort
# Date: April 2014
# Version: 1.0
#


DEBUG=0

#---------------------------
#------   DEBUG   ----------
  if [ $DEBUG -eq 1 ]
  then	echo $*
  fi
#----  END DEBUG   ---------
#---------------------------

DIR=`dirname $0`"/../bin/"
BINARY="$DIR""/clustalo"
CMD="$BINARY $*"

#---------------------------
#------   DEBUG   ----------
  if [ $DEBUG -eq 1 ]
  then	echo "$CMD"
  fi
#----  END DEBUG   ---------
#---------------------------

eval "$CMD"

exit 0

