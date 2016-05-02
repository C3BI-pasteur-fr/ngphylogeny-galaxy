#!/bin/bash

# This a shell wrapper to integrate automaticDetection into Galaxy
#
# Author: C. Vernette, V. Lefort
# Date: June 2014
# Version: 1.0
#

DEBUG=1

input=$1
choice=$2
output=$3
temp=$RANDOM
echo $choice > $temp

##test datatype##

test=`cat $input| cut -c -1`      # prob avec | head -n 5 
test=`echo $test | sed -e "s/>//g"`

for i in $test 
do	
	if [ $i == "a" ]||[ $i == "A" ]||[ $i == "t" ]||[ $i == "T" ]||[ $i == "c" ]||[ $i == "C" ]||[ $i == "g" ]||[ $i == "G" ]||[ $i == "n" ]||[ $i == "N" ]
	then 	echo ""> /dev/null 
	else	prot="prot"
	fi
done
if [[ $prot == "prot" ]]
then 	echo "prot" >> $temp 
else	echo "nucleo" >> $temp
fi

##account number sequence##

# i.e. count number of lines beggining with '>'

nb=`grep "^>" $input | wc -l`
echo $nb >> $temp

mv ${temp} ${output}

exit 0


ne marche pas donne nucleo a tous les coup 
detect au moins un des carac recherché sur chaque ligne

# 1st sed: remove lines beginig by '>'
# 2nd sed: remove empty lines
# 3rd sed: remove lines containing nucleotides
# wc -l: count number of lines (=0 when nucleic data)

if [ `sed -e "/^>/d" $input | sed -e "/^$/d" | sed -e "/[aAcCgGtTnN]/d" | wc -l` -eq 0 ]
then	echo "nucleo" >> $temp
else	echo "prot" >> $temp 
fi

