#!/bin/bash

dir0="/Users/ehresms/computational/rloop"
aligndir=${dir0}/align_trimmed
splitdir=${dir0}/split_sam

files=$(ls ${aligndir})

mkdir ${splitdir}

for file in ${files}; do

	check="bad"

	name=$(echo $file | cut -d '.' -f1)

	if [ -f ${splitdir}/${name}_forward.sam ]; then
		echo "already split"
	
	else

		samtools view -h -f 18 -F 4 -@ 16 ${aligndir}/${file} > ${splitdir}/${name}_reverse.sam
		samtools view -h -f 34 -F 4 -@ 16 ${aligndir}/${file} > ${splitdir}/${name}_forward.sam

		check=$(samtools quickcheck ${splitdir}/${name}_forward.sam)

		if [ -z "${check}" ]; then
			echo "split successful, removing original file"

			rm ${aligndir}/${file}

		else

			echo "split not successful"

		fi

	fi
	
done

