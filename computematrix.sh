#!/bin/bash

dir0=~/computational
bwdir=$dir0/rloop/bigwig
genome=$dir0/genomes/droso/annotations/final_dmel-all-r6.32.bed
matdir=$dir0/rloop/matrix

mkdir -p $matdir

conditions="S2 6 10"
orientations="forward reverse"
treatments="IP input RN_IP RN_input"

cd $bwdir

for condition in $conditions; do
	
	for orientation in $orientations; do	

		files=$(ls $bwdir | grep -e $orientation)

		IP=$(echo "$files" | grep -e $condition | grep -v "RN" | grep -v "input" | tr '\n' ' ')
		input=$(echo "$files" | grep -e $condition | grep -v "RN" | grep -e "input" | tr '\n' ' ')
		RN_IP=$(echo "$files" | grep -e $condition | grep -e "RN" | grep -v "input" | tr '\n' ' ')
		RN_input=$(echo "$files" | grep -e $condition | grep -e "RN" | grep -e "input" | tr '\n' ' ')


		for treatment in $treatments; do

			computeMatrix reference-point --referencePoint TSS \
				-b 1000 -a 3000 \
				-R $genome \
				-S $(echo "${!treatment}") \
				-p 12 \
				-o $matdir/${condition}_${treatment}_${orientation}_TSS.gz \
			
			computeMatrix\
				-b 1000 -a 3000 \
				-R $genome \
				-S $(echo "${!treatment}") \
				-p 12 \
				-o $matdir/${condition}_${treatment}_${orientation}_mid.gz \

		done
	done
done

cd $dir0/scripts
