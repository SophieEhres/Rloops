#!/bin/bash
exec 2>./bowtie_align_trimmed.log

dir0="/Users/ehresms/computational"
genomedir=${dir0}/genomes/droso/bowtie
loopdir=${dir0}/rloop
aligndir=${loopdir}/align_trimmed
fastadir=${loopdir}/trim

mkdir ${aligndir}

	samples=$(ls ${fastadir} | grep -e "paired" | cut -d '_' -f1-2 | sort -u)
	
	echo "Samples are ${samples}"

	for name in ${samples}; do
		
		echo "Name is ${name}"

		if [ -f ${aligndir}/${name}_aligned.sam ]; then

			echo "already aligned"
		
		else

			file1=$(ls ${fastadir}/*.fq |grep -e ${name}_ |grep -e "R1" )  
			file2=$(ls ${fastadir}/*.fq |grep -e ${name}_ |grep -e "R2" )

		
			if [ -z ${file1} ]; then

				echo "unzipping files"

				zipped="yes"

				zipped1=$(ls ${fastadir}/*.gz |grep -e ${name}_ |grep -e "R1" )  
				tar -zxvf ${zipped1} -C ${fastadir}
				
				zipped2=$(ls ${fastadir}/*.gz |grep -e ${name}_ |grep -e "R2" )  
				tar -zxvf ${zipped2} -C ${fastadir}


				file1=$(ls ${fastadir}/*.fq |grep -e ${name}_ |grep -e "R1" )  
				file2=$(ls ${fastadir}/*.fq |grep -e ${name}_ |grep -e "R2" )
				
			fi


			echo "file1 is ${file1}, file 2 is ${file2}"  

			 bowtie2 -q -p 12 -x ${genomedir}/bowtie_droso -1 ${file1} -2 ${file2} \
				 -S ${aligndir}/${name}_aligned.sam
			
			if [ ${zipped} == "yes" ]; then
				rm $file1 $file2

			fi
			
		fi

	done

done
