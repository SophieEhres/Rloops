#!/bin/bash

dir0="/Users/ehresms/computational"
bwdir=${dir0}/rloop/bigwig
genome=${dir0}/genomes/droso/annotations/final_dmel-all-r6.32.bed
matdir=${dir0}/rloop/matrix

mkdir -p ${matdir}

conditions=$(ls ${bwdir} | grep -e "final" | cut -d "-" -f1 | uniq)


for condition in ${conditions}; do
	echo "computing for ${condition}"

	files=$(ls $bwdir/*.bw | grep -e $condition | grep -e "final" | tr "\n" " " )
	
	echo "files are ${files}"

	computeMatrix reference-point --referencePoint TSS \
		-b 2500 -a 2500 \
		-R ${genome} \
		-S ${files} \
		-p 12 \
		-o ${matdir}/${condition}_TSS.gz \
	
	computeMatrix scale-regions\
		-b 1500 -a 1500 \
		-R ${genome} \
		-S ${files} \
		-p 12 \
		-o ${matdir}/${condition}_mid.gz \


done
