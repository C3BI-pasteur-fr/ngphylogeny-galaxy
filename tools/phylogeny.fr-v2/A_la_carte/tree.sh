#!/bin/bash

DEBUG=1

while getopts a:b:c:d:e:f:g:i:j:k:l:o: option
do
	case $option in
	a)
		choice=$OPTARG
	;;
	b)
		bo=$OPTARG
		boot1=`echo $bo | cut -d " " -f 1`
		replicates=`echo $bo | cut -d " " -f 2`
	;;
	c)
		option=$OPTARG    
		model=`echo $option | cut -d " " -f 1`
		datatype=`echo $option | cut -d " " -f 2`
		gamma1=`echo $option | cut -d " " -f 3`
		equilibrium=`echo $option | cut -d " " -f 4`
	;;
	d)
		rate=$OPTARG
	;;
	e)
		option2=$OPTARG		
		method=`echo $option2 | cut -d " " -f 1`
		NNI=`echo $option2 | cut -d " " -f 2`
		SPR=`echo $option2 | cut -d " " -f 3`
		removeGap=`echo $option2 | cut -d " " -f 4`
	;;
	f)
		conditional=$OPTARG
		support=`echo $conditional | cut -d " " -f 1`
		type=`echo $conditional | cut -d " " -f 2`
		gamma=`echo $conditional | cut -d " " -f 3`
		search=`echo $conditional | cut -d " " -f 4`
	;;
	g)
		boot=$OPTARG
		outputBT=`echo $boot | cut -d " " -f 1`
		number=`echo $boot | cut -d " " -f 2`
	;;
	i)
		input=$OPTARG
	;;
	j)
		option3=$OPTARG
		prop_invar=`echo $option3 | cut -d " " -f 1`
		model=`echo $option3 | cut -d " " -f 2`
		search=`echo $option3 | cut -d " " -f 3`
		equiSeq=`echo $option3 | cut -d " " -f 4`
		points=`echo $option3 | cut -d " " -f 5`
	;;
	k)
		tstv=$OPTARG
	;;
	l)
		option4=$OPTARG
		categories=`echo $option4 | cut -d " " -f 1`
		shape=`echo $option4 | cut -d " " -f 2`
	;;		
	o)
		output=$OPTARG
	;;
	*)
	;;
	esac
done 

DIR=`dirname $0`"/../bin/"

if [[ $choice == "fastme" ]]
then	BINARY="$DIR"/"fastme"
	CMD="$BINARY -i $input -o $output"
	if [[ $boot1 == "true" ]]
	then	CMD="$CMD -b $replicates"
	fi	
	if [[ $datatype == "d" ]]
	then	CMD="$CMD -D $model"
	else	CMD="$CMD -P $model"
	fi 
	CMD="$CMD $equilibrium"
	if [[ $gamma1 == "true" ]]
	then	CMD="$CMD -g $rate"
	fi
	CMD="$CMD $removeGap -m $method -n $NNI $SPR -w b" 											
fi
if [[ $choice == "phyml" ]]
then 	BINARY="$DIR""/phyml"	
	CMD="$BINARY"
	if [[ $support == "boot" ]] 
 	then	CMD="$CMD -b $number"
	fi
	CMD="$CMD -i $input -d $type  -v $prop_invar -m $model  -s $search -f $equiSeq"
	if [[ $type == "nt" ]] 
 	then	CMD="$CMD -t $tstv"
	fi
	if [[ $gamma == "true" ]] 
	then	CMD="$CMD -c $categories -a $shape" 
	else 	CMD="$CMD -c 1"
	fi
	if [[ $support == "sh" ]] 
 	then	CMD="$CMD -b -4"
	elif 	[[ $support == "aBayes" ]]
	then	CMD="$CMD -b -5"
	elif 	[[ $support == "no" ]]
	then	CMD="$CMD -b -0"
	fi
	if [[ $search == "SPR" ]] 
	then 	CMD="$CMD --rand_start 0 --n_rand_starts $points"
	elif [[ $search == "BEST" ]] 
	then	 CMD="$CMD --rand_start 0 --n_rand_starts $points"
	fi
 	CMD="$CMD --no_memory_check >/dev/null"
fi

#---------------------------
#------   DEBUG   ----------
if [ $DEBUG -eq 1 ]
then	echo "$CMD"
fi
#----  END DEBUG   ---------
#---------------------------

eval "$CMD"

if [[ $choice == "phyml" ]]
then	tree_suffix=_phyml_tree.txt
	boot_tree_suffix=_phyml_boot_trees.txt
	mv ${input}${tree_suffix} ${output}
	if [[ $support == "boot" ]]
	then	mv ${input}${boot_tree_suffix} ${outputBT}
	fi
fi

exit 0

