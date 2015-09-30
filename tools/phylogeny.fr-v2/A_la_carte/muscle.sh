#!/bin/bash

# This wrapper was created by Southgreen
# to encapsulate PhyML in Galaxy.
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
BINARY="$DIR""/muscle"
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
