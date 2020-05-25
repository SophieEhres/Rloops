#!/bin/bash
exec 2>./split_sam.log

dir0="/Users/ehresms/computational/rloop"
aligndir=${dir0}/align_trimmed
splitdir=${dir0}/split_sam

files=$(ls ${aligndir} )

mkdir ${splitdir}

for file in ${files}; do

	check_F="bad" #assign default "bad split" value
	check_R="bad"

	name=$(echo $file | rev | cut -d '.' -f2- | rev)

	if [ -f "${splitdir}/${name}_forward.sam" ]; then #check if file has already been split and exists in splitdir

		echo "already split"
	
	else

		echo "splitting ${name}"

		samtools view -h -f 16 -F 4 -b -@ 16 ${aligndir}/${file} > ${splitdir}/${name}_reverse1.tmp #split reverse using SAM flags (https://broadinstitute.github.io/picard/explain-flags.html)
		samtools view -h -f 83 -F 4 -b -@ 16 ${aligndir}/${file} > ${splitdir}/${name}_reverse2.tmp #output in non-sorted bam files to save space

		tomerge=$(ls ${splitdir}/*.tmp | tr "\n" " ")

		samtools merge -f -n -@ 16 ${splitdir}/${name}_reverse.bam ${tomerge} #merge reverse bam files

		check_R=$(samtools quickcheck ${splitdir}/${name}_reverse.bam 2>&1) #check integrity of merged bam file. Should output nothing.

		if [ -z "${check_R}" ]; then #stop if check_R has a value (either "bad" or error output from quickcheck)

			echo "😀Reverse split successful, splitting Forward"

			rm ${splitdir}/*.tmp #remove temp bam files

			samtools view -h -f 147 -F 4 -b -@ 16 ${aligndir}/${file} > ${splitdir}/${name}_forward1.tmp
			samtools view -h -f 99 -F 4 -b -@ 16 ${aligndir}/${file} > ${splitdir}/${name}_forward2.tmp
			
			tomerge=$(ls ${splitdir}/*.tmp | tr "\n" " ")

			samtools merge -f -n -@ 16 ${splitdir}/${name}_forward.bam ${tomerge} #merge forward bam files

			check_F=$(samtools quickcheck ${splitdir}/${name}_forward.bam 2>&1)

			if [ -z "${check_F}" ]; then #stop if check_F has a value

				echo "😀Forward split successful, transforming sam into bam file" #remove original sam file and temp bam files

				samtools view -@ 16 -S -b ${aligndir}/${file} > ${aligndir}/${name}.bam

				rm ${splitdir}/*.tmp

			else

			echo "😭Forward split not successful" #remove tmp bam files and echo error message
			rm ${splitdir}/*.tmp

			fi


		else

			echo "😭Reverse split not successful" #remove tmp bam files and echo error message

			rm ${splitdir}/*.tmp

		fi

	fi
	
done