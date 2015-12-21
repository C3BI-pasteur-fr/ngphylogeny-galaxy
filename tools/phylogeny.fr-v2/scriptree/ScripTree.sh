#!/bin/bash

# This a shell wrapper to integrate Clustal Omega into Galaxy
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

##unpacking##

DIR=`dirname $0`"/../bin/"
ARCHIVE="$DIR""/scriptree.zip"
cp "$ARCHIVE" .
unzip `basename "$ARCHIVE"`

##options##

while getopts a:b:c:d:e:f:g:i:j:o:p:q:r:s:t:u:v:y:z: option
do
	case $option in
	a)
		fileNewick=$OPTARG
	;;	
	b)
		tree=$OPTARG
		nbColumns=`echo $tree | cut -d " " -f 1`
		nbConformation=`echo $tree | cut -d " " -f 2`
		type=`echo $tree | cut -d " " -f 3`
		size=`echo $tree | cut -d " " -f 4`
		style=`echo $tree | cut -d " " -f 5`
		nbInterleaf=`echo $tree | cut -d " " -f 6`
		typeOrientation=`echo $tree | cut -d " " -f 7`
#		root=`echo $tree | cut -d " " -f 8`
	;;
	c)
		branch=$OPTARG
		nbRound=`echo $branch | cut -d " " -f 1`
		nbThreshold=`echo $branch | cut -d " " -f 2`
		supportBranchColor=`echo $branch | cut -d " " -f 3`
		whereSupportBranch=`echo $branch | cut -d " " -f 4`
		typeSupport=`echo $branch | cut -d " " -f 5`
		sizeSupport=`echo $branch | cut -d " " -f 6`
		styleSupport=`echo $branch | cut -d " " -f 7`
	;;	
	d)
		support=$OPTARG 
		nbRound2=`echo $support | cut -d " " -f 1`
		nbThreshold2=`echo $support | cut -d " " -f 2`
		supportBranchColor2=`echo $support | cut -d " " -f 3`
		whereSupportBranch2=`echo $support | cut -d " " -f 4`
		typeSupport2=`echo $support | cut -d " " -f 5`
		sizeSupport2=`echo $support | cut -d " " -f 6`
		styleSupport2=`echo $support | cut -d " " -f 7`
	;;
	e)
		annotation=$OPTARG
		annotationChoice=`echo $annotation | cut -d " " -f 1`
		fileAnnotation=`echo $annotation | cut -d " " -f 2`
	;;
	f)
		lba=$OPTARG
		lbaWhat=`echo $lba | cut -d " " -f 1`
		lbaType=`echo $lba | cut -d " " -f 2`
		lbaSize=`echo $lba | cut -d " " -f 3`
		lbaStyle=`echo $lba | cut -d " " -f 4`
		lbaColor=`echo $lba | cut -d " " -f 5`
		lbaWidth=`echo $lba | cut -d " " -f 6`
	;;
	g)
		lsa=$OPTARG
		lsaWhat=`echo $lsa | cut -d " " -f 1`
		lsaType=`echo $lsa | cut -d " " -f 2`
		lsaSize=`echo $lsa | cut -d " " -f 3`
		lsaStyle=`echo $lsa | cut -d " " -f 4`
		lsaColor=`echo $lsa | cut -d " " -f 5`
	;;
	i)
		lya=$OPTARG
		lyaWhat=`echo $lya | cut -d " " -f 1`
 		lyaSymbol=`echo $lya | cut -d " " -f 2` 
		lyaColor=`echo $lya | cut -d " " -f 3`
	;;
	j)
		qa=$OPTARG
		qaOperation=`echo $qa | cut -d " " -f 1`
		qaColor=`echo $qa | cut -d " " -f 2`
		

	;;
#	k)
#		qa2=$OPTARG
#		qaOperation2=`echo $qa2 | cut -d " " -f 1`
#		qaColor2=`echo $qa2 | cut -d " " -f 2`
#	;;
#	p)
#		queryChoice2=$OPTARG
#	;;
	q)
		queryChoice=$OPTARG
	;;
	r)
		symbolChoice=$OPTARG
	;;
	s)
		stringChoice=$OPTARG
	;;
	t)
		bracketChoice=$OPTARG
	;;
	o)
		output=$OPTARG
	;;
	u)
		supportChoice=$OPTARG
	;;
	v)
		branchChoice=$OPTARG
	;;
	y)
		drawingChoice=$OPTARG							
	;;
	z)
              	script=$OPTARG
		choice=`echo $script | cut -d " " -f 1`
		fileScript=`echo $script | cut -d " " -f 2`
	;;
	*)
	;;
	esac
done

##writing the fileTree used in command line##

treeFile=$RANDOM 
tree="tree"
echo $tree>$treeFile
if [[ $drawingChoice == "true" ]]
then 	tree="tree -columns $nbColumns -conformation $nbConformation -font {$type $size $style } -interleaf $nbInterleaf -orientation $typeOrientation"
#	if [[  -n ${root}  ]]
#	then tree="$tree -root {$root }"
#	fi
	echo $tree>$treeFile 
fi
if [[ $branchChoice == "true" ]]
then	esn="esn -what :x -box 0 -fg $supportBranchColor -where $whereSupportBranch -font {$typeSupport $sizeSupport $styleSupport } -round $nbRound -threshold $nbThreshold"
	echo $esn>>$treeFile 
fi
if [[ $supportChoice == "true" ]]
then	esn="esn -what x: -box 0 -fg $supportBranchColor2 -where $whereSupportBranch2 -font {$typeSupport2 $sizeSupport2 $styleSupport2} -round $nbRound2 -threshold $nbThreshold2"
	echo $esn>>$treeFile 
fi

if [[ $annotationChoice == "true" ]]
then	if [[ $bracketChoice == "true" ]]
	then 	lba="lba -what {$lbaWhat } -font {$lbaType $lbaSize $lbaStyle } -bg $lbaColor -width $lbaWidth"
		echo $lba>>$treeFile
	fi
	if [[ $stringChoice == "true" ]] 
	then 	lsa="lsa -what {$lsaWhat } -font {$lsaType $lsaSize $lsaStyle } -fg $lsaColor"
		echo $lsa>>$treeFile
	fi
	if [[ $symbolChoice == "true" ]]
	then	lya="lya -what {$lyaWhat } -symbol $lyaSymbol -bg $lyaColor"
		echo $lya>>$treeFile
	fi
	if  [[  $queryChoice == "true"  ]]							
	then	qaWhat=`echo "$qa" | sed -e  "s/$qaOperation//g"`
		qaWhat=`echo "$qaWhat" | sed -e  "s/$qaColor//g"`
	fi
	if [[ -n ${qaWhat} ]]
	then 	qaWhat=`echo $qaWhat | sed -e"s/__pd__/#/g"`
		qa="qa -hi { -o {$qaOperation } -c $qaColor } -q {$qaWhat }"
		echo $qa>>$treeFile
	fi
#	if [[  $queryChoice2 == "true"  ]]
#		qaWhat2=`echo "$qa2" | sed -e  "s/$qaOperation2//g"`
#		qaWhat2=`echo "$qaWhat2" | sed -e  "s/$qaColor2//g"`
#	fi
#	if [[ -n ${qaWhat2} ]]
#	then 	qaWhat2=`echo $qaWhat2 | sed -e"s/__pd__/#/g"`
#		qa2="qa -hi { -o {$qaOperation2 } -c $qaColor2 } -q {$qaWhat2 }"
#		echo $qa2>>$treeFile
#	fi
fi

##annotation written directly by user##

if [[  $annotationChoice == "write"  ]] 
then 	writeAnnot=`echo $annotation | sed -e "s/$annotationChoice//g"`
	writeAnnot=`echo $writeAnnot | sed -e"s/$fileAnnotation//g"`
	writeAnnot=`echo $writeAnnot | sed -e"s/__oc__/{/g"`
	writeAnnot=`echo $writeAnnot | sed -e"s/__cc__/}/g"`
	writeAnnot=`echo $writeAnnot | sed -e"s/__cr____cn__/\n/g"`
	echo "$writeAnnot">annotation.txt

	#---------------------------
	#------   DEBUG   ----------
   	if [ $DEBUG -eq 1 ]
   	then	export annot="$(cat annotation.txt)" 		
	   echo
	   echo "file annotation.txt:"
	   echo "$annot"
   	fi
	#----  END DEBUG   ---------
	#---------------------------
fi

##script written directly by user##

if [[  $choice == "write" ]] 
then	writeScript=`echo $script | sed -e "s/$fileScript//g"`
	writeScript=`echo $writeScript | sed -e "s/$choice//g"`
	writeScript=`echo "$writeScript" | sed -e"s/\*//g"`
	writeScript=`echo $writeScript | sed -e"s/__oc__/{/g"`
	writeScript=`echo $writeScript | sed -e"s/__cc__/}/g"`
	writeScript=`echo $writeScript | sed -e"s/__pd__/#/g"`
	writeScript=`echo $writeScript | sed -e"s/__cr____cn__/\n/g"`	
	echo "$writeScript">$treeFile
fi

#---------------------------
#------   DEBUG   ----------
   if [ $DEBUG -eq 1 ]
   then	export script="$(cat $treeFile)"   			
	echo
	echo "file $treeFile:"
	echo "$script"
   fi
#----  END DEBUG   ---------
#---------------------------

##commande line##

binary="./scriptree"

if [[ $choice == "file" ]]
then	CMD="$binary -tree $fileNewick -script $fileScript -out $output"
else	CMD="$binary -tree $fileNewick -script $treeFile -out $output"
fi
if [[ $annotationChoice == "true"  ]]
then 	CMD="$CMD -annotation $fileAnnotation "
fi
if [[ $annotationChoice == "write"  ]]
then 	CMD="$CMD -annotation annotation.txt "
fi
echo 

##test input file format##

if [  `cat $fileNewick | head -n 1 | cut -c1` != '(' ]
then 	echo "Wrong file tree, format Newick? Not executed program"
	exit 0
fi
if [  `cat $treeFile | head -n 1 | cut -d " " -f 1` != 'tree' ]
then 	echo "Wrong file script. Not executed program"
	exit 0
fi
#if [[ $CMD == *-annotation\ \/* ]]					
#then 	fistLine=`cat  $fileAnnotation | head -n 1`
#	if  [[  $fistLine !=  *\{* ]]
#	then 	echo "Wrong file annotation. Not executed program"
#		exit 0
#	fi
#fi

#---------------------------
#------   DEBUG   ----------
   if [ $DEBUG -eq 1 ]
   then	echo "$CMD"
   fi
#----  END DEBUG   ---------
#---------------------------

eval "$CMD"

pre=".svg"
mv ${output}${pre} ${output}

exit 0
