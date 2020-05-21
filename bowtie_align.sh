#!/bin/bash
exec 2>./bowtie_align_trimmed.log

echo "Bowtie align launched on $(date)" 1>&2

dir0="/Users/ehresms/computational"
genomedir=${dir0}/genomes/droso/bowtie
loopdir=${dir0}/rloop
aligndir=${loopdir}/align_trimmed
trimdir=${loopdir}/trim
splitdir=${loopdir}/split_sam

mkdir ${aligndir}

samples=$(ls ${trimdir} | grep -e "paired" | rev |cut -d '_' -f4- | rev | sort -u)

echo "Samples are ${samples}"

for name in ${samples} ; do		

	split=$(ls ${splitdir}/*.bam | grep -e "${name}_" | head -n 1)
	echo "split is ${split}"
	echo "Name is ${name}"


	if [ -f "${aligndir}/${name}_aligned.sam" ] ; then

		echo "already aligned"

	elif test -n "${split}" ; then

		echo "already aligned and split"

	else

		echo "${name} not found in align and split directories; proceeding to trimming"

		file1=$(ls ${trimdir}/*.fq |grep -e ${name}_ |grep -e "R1" | grep -v "unpaired" )  
		file2=$(ls ${trimdir}/*.fq |grep -e ${name}_ |grep -e "R2" | grep -v "unpaired" )

		echo "checking trim files, unzipped is ${file1}"
	
		if [ -z "${file1}" ]; then

			echo "unzipping files"

			zipped="yes"

			zipped1=$(ls ${trimdir}/*.gz |grep -e ${name}_ |grep -e "R1" )  
			tar -zxvf ${zipped1} -C ${trimdir}
			
			zipped2=$(ls ${trimdir}/*.gz |grep -e ${name}_ |grep -e "R2" )  
			tar -zxvf ${zipped2} -C ${trimdir}


			file1=$(ls ${trimdir}/*.fq |grep -e ${name}_ |grep -e "R1" )  
			file2=$(ls ${trimdir}/*.fq |grep -e ${name}_ |grep -e "R2" )
		
		elif [ -f "${file1}" ]; then

			echo "files not zipped, will zip after alignment"
			zipped="no"

		else 

			echo "no trim file found, check file"
			exit 1

		fi


		echo "file1 is ${file1}, file 2 is ${file2}"  

		bowtie2 -q -p 12 -x ${genomedir}/bowtie_droso -1 ${file1} -2 ${file2} \
			-S ${aligndir}/${name}_aligned.sam
		
		if [ "${zipped}" == "yes" ]; then

			echo "removing non-zipped files"
			# rm $file1 $file2

		elif [ "${zipped}" == "no" ]; then

			echo "zipping remaining files and removing non-zipped files"


		fi
		
	fi

done

