#!/bin/sh

# This a shell wrapper to integrate BMGE into Galaxy
#
# Author: C. Vernette, V. Lefort
# Date: April 2014
# Version: 1.0
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
BINARY="$DIR/BMGE.jar"
CMD="java -jar $BINARY $*"

#---------------------------
#------   DEBUG   ----------
if [ $DEBUG -eq 1 ]
then	echo "$CMD"
fi
#----  END DEBUG   ---------
#---------------------------

eval "$CMD"

exit 0

