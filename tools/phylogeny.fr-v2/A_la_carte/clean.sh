#!/bin/bash

# This a shell wrapper to integrate cleans into Galaxy
#
# Author: C. Vernette, V. Lefort
# Date: June 2014
# Version: 1.0
#

DEBUG=1

while getopts a:b:c:d:e:f:g:h:i:o:z: option
do
	case $option in
	a)
		binaire=$OPTARG
	;;
	b)
		gblocks=$OPTARG
		datatype=`echo $gblocks | cut -d " " -f 1`
		b1=`echo $gblocks | cut -d " " -f 2`
		b2=`echo $gblocks | cut -d " " -f 3`
		b3=`echo $gblocks | cut -d " " -f 4`
		b4=`echo $gblocks | cut -d " " -f 5`
		b5=`echo $gblocks | cut -d " " -f 6`
	;;
	c)
		BMGE=$OPTARG
		codeSeq=`echo $BMGE | cut -d " " -f 1`
		matrice=`echo $BMGE | cut -d " " -f 2`
		windowsSize=`echo $BMGE | cut -d " " -f 3`
		rateCutOff=`echo $BMGE | cut -d " " -f 4`
		minBlock=`echo $BMGE | cut -d " " -f 5`
		formats=`echo $BMGE | cut -d " " -f 6`
	;;
	d)
		choice=$OPTARG
	;;
	e)
		selection=$OPTARG
	;;
	f)
		gtin=$OPTARG
	;;
	g)
		stin=$OPTARG
	;;
	h)
		consin=$OPTARG
	;;
	i)
		input=$OPTARG
	;;
	o)
		output=$OPTARG
	;;
	z)
		clean=$OPTARG
	;;
	*)
	;;
	esac
done

if [[ $clean == "true" ]]
then
	DIR=`dirname $0`"/../bin/"

	if [[ $binaire == "gblocks" ]]
	then
	 	aln_suffix=-gb
		phylip_suffix=.phylip
		phytmp=`dirname "$output"`/$RANDOM
		BINARY="$DIR""/gblocksConv.pl"
		CMD="perl $BINARY $input $phytmp >/dev/null"
		eval "$CMD"
		nbseq=`head -n 1 "$phytmp" | cut -d " " -f 2` 
		rm $phytmp
		BINARY="$DIR/Gblocks"
		CMD="$BINARY $input -b1=$((nbseq * b1 / 100 + 1)) -b2=$((nbseq * b2 / 100 + 1)) -t=$datatype -b3=$b3 -b4=$b4 -b5=$b5"
	fi
	if [[ $binaire == "BMGE" ]]
	then
	 	BINARY="$DIR/BMGE.jar"
		CMD="java -jar $BINARY -i $input -t $codeSeq -m $matrice -w $windowsSize -g $rateCutOff -b $minBlock -o$formats  $output"
	fi
	if [[ $binaire == "trimal" ]]
	then
	 	BINARY="$DIR/trimal"
		if [[ $choice == "default" ]]
		then
			CMD="$BINARY -in $input -out $output $selection -phylip"
		else
		 	CMD="$BINARY -in $input -out $output -phylip"
			if [[ -n $gtin ]]
			then
				CMD="$CMD -gt $gtin"
			fi
			if [[ -n $stin ]]
			then
				CMD="$CMD -st $stin"
			fi
			if [[ -n $consin ]]
			then
				CMD="$CMD -cons $consin"
			fi
		fi
	fi
	#---------------------------
	#------   DEBUG   ----------
   	   if [ $DEBUG -eq 1 ]
   	   then	 echo "$CMD"
   	   fi
	#----  END DEBUG   ---------
	#---------------------------

	eval "$CMD"

	if [[ $binaire == "gblocks" ]]
	then
	 	mv ${input}${aln_suffix} ${output}
		BINARY="$DIR""/gblocksConv.pl"
		CMD="perl $BINARY $output $output$phylip_suffix >/dev/null"
		eval "$CMD"
		mv ${output}${phylip_suffix} ${output}
	fi
fi

exit 0

