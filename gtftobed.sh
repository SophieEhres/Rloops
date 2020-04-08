#!/bin/bash

dir0=~/computational
beddir=$dir0/genomes/droso/annotations
name=$(ls $beddir | grep -e ".gtf" | rev | cut -c 4- | rev )

cat $beddir/${name}gtf | \
	awk 'BEGIN {OFS="\t"} {print $1,$4,$5,NR,".",$7}' >> $beddir/${name}bed

sort -k 1,1 -k2,2n $beddir/${name}bed >> $beddir/sorted_${name}bed 

mergeBed -s -i $beddir/sorted_${name}bed -s -delim "\t" -c 4,5,6 -o distinct >> $beddir/final_${name}bed
