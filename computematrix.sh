#!/bin/bash

dir0="/Users/ehresms/computational"
bwdir=${dir0}/rloop/bigwig
genome=${dir0}/genomes/droso/annotations/final_dmel-all-r6.32.bed
matdir=${dir0}/rloop/matrix
beddir=${dir0}/rloop/consensus_bed
all_reference=$(ls ${dir0}/rloop/consensus_bed/*.bed | grep -e "all")

mkdir -p ${matdir}

conditions=$(ls ${bwdir} | grep -e "final" | cut -d "-" -f1 | uniq)

if echo "checking ${all_reference} file" | grep -v "both"; then
	cat ${all_reference} > ${beddir}/consensus_peak_all_both.bed
fi

all_reference_file=${beddir}/consensus_peak_all_both.bed


for condition in ${conditions}; do
	echo "computing for ${condition}"

	files=$(ls $bwdir/*.bw | grep -e $condition | grep -e "final" | tr "\n" " " )

	echo "files are ${files}"

	reference=$(ls ${beddir}/*.bed | grep -e ${condition})

		
	if echo "checking ${reference} file" | grep -v "both"; then
		cat ${reference} > ${beddir}/consensus_peak_${condition}_both.bed
	fi

	reference_file=${beddir}/consensus_peak_${condition}_both.bed


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
		-o ${matdir}/${condition}_TSS-scale.gz \

	computeMatrix reference-point --referencePoint TSS \
		-b 2500 -a 2500 \
		-R ${reference_file} \
		-S ${files} \
		-p 12 \
		-o ${matdir}/${condition}_reference.gz \

	computeMatrix scale-regions \
		-b 2500 -a 2500 \
		-R ${reference_file} \
		-S ${files} \
		-p 12 \
		-o ${matdir}/${condition}_reference-scale.gz \

	computeMatrix reference-point --referencePoint TSS \
		-b 2500 -a 2500 \
		-R ${all_reference_file} \
		-S ${files} \
		-p 12 \
		-o ${matdir}/${condition}_reference-all.gz \

	computeMatrix scale-regions \
		-b 2500 -a 2500 \
		-R ${all_reference_file} \
		-S ${files} \
		-p 12 \
		-o ${matdir}/${condition}_reference-all-scale.gz \

done
