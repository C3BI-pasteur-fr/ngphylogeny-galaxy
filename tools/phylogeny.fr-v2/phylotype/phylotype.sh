#!/bin/bash

# This a shell wrapper to integrate PhyloType into Galaxy
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
ARCHIVE="$DIR""/phylotype.zip"

cp "$ARCHIVE" .
unzip `basename "$ARCHIVE"`

while getopts b:c:d:e:f:g:i:o: option
do
	case $option in
	b)
		fileTree=$OPTARG
	;;
	c)
		fileAnnot=$OPTARG
	;;
	d)
		variableListe=$OPTARG
	;;
	e)
		interface=$OPTARG
		size=`echo $interface | cut -d " " -f 1`
		persistence=`echo $interface | cut -d " " -f 2`
		ratio=`echo $interface | cut -d " " -f 3`
	;;
	f)
		interface2=$OPTARG
		total=`echo $interface2 | cut -d " " -f 1`
		different=`echo $interface2 | cut -d " " -f 2`
		local=`echo $interface2 | cut -d " " -f 3`
		global=`echo $interface2 | cut -d " " -f 4`
		diversity=`echo $interface2 | cut -d " " -f 5`
		ratio2=`echo $interface2 | cut -d " " -f 6`
		ratio3=`echo $interface2 | cut -d " " -f 7`
		support=`echo $interface2 | cut -d " " -f 8`
		global2=`echo $interface2 | cut -d " " -f 9`
	;;
	g)
		shuffling=$OPTARG
		iteration=`echo $shuffling | cut -d " " -f 1`
		treshold=`echo $shuffling | cut -d " " -f 2`
	;;
	i)
		ancestral=$OPTARG
	;;
	o)
		output=$OPTARG
	;;
	*)
	;;
	esac
done

##writing the file used in command line##

file=$RANDOM
echo "set S(analysisname) analyseName;">$file
echo "set S(analysispath) [pwd]" >>$file
echo "set S(file-tree) $fileTree ;">>$file
echo "set S(file-annotation) $fileAnnot ;">>$file
echo "set S(variables) {$variableListe } ;">>$file
echo "set S(criteriathreshold,sz) $size ;">>$file
echo "set S(criteriathreshold,ps) $persistence ;">>$file
echo "set S(criteriathreshold,szdf) $ratio ;">>$file
echo "set S(criteriathreshold,tt) $total ;">>$file
echo "set S(criteriathreshold,df) $different ;" >>$file
echo "set S(criteriathreshold,sl) $local ;" >>$file
echo "set S(criteriathreshold,sg) $global ;" >>$file
echo "set S(criteriathreshold,dv) $diversity ;" >>$file
echo "set S(criteriathreshold,sldv) $ratio2 ;" >>$file
echo "set S(criteriathreshold,sgdv) $ratio3 ;" >>$file
echo "set S(criteriathreshold,sp) $support ;" >>$file
echo "set S(criteriathreshold,spg) $global2 ;" >>$file
echo "set S(aainference) $ancestral ;" >>$file
echo "set S(includingoutroupcheck) 0 ;" >>$file
echo "set S(shufflingiteration) $iteration" >>$file
echo "set S(pvaltreshold) $treshold ;" >>$file

echo				
echo "contents of the file $file:"  
cat $file    		 
echo

##binary in Tcl/Tk##

BINARY="./etcl pbm05.tcl -p"
CMD="$BINARY $file"

#---------------------------
#------   DEBUG   ----------
if [ $DEBUG -eq 1 ]
then	echo "$CMD"
fi
#----  END DEBUG   ---------
#---------------------------

eval $CMD

rm $file
out="_output.csv"
mv "phylotype${analyseName}${out}" "$output"



exit 0

