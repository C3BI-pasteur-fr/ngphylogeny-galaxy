#!/bin/bash

# This a shell wrapper to integrate example into Galaxy
#
# Author: C. Vernette, V. Lefort
# Date: April 2014
# Version: 1.0
#

DEBUG=1

DIR=`dirname $0`"/../bin/"
BINARY="$DIR""/binaire"
CMD="$BINARY $*"

#---------------------------
#------   DEBUG   ----------
   if [ $DEBUG -eq 1 ]
   then	 echo "$CMD"
   fi
#----  END DEBUG   ---------
#---------------------------

#eval "$CMD"

exit 0

