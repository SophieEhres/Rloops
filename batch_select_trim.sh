#!/bin/bash

computedir=/Users/ehresms/computational
fastadir=${computedir}/rloop/fasta
loopdir=${computedir}/rloop
groupdir=${loopdir}/fasta_grouped
trimdir=${loopdir}/trim
trimmomatic=${computedir}/tools/Trimmomatic-0.39/trimmomatic-0.39.jar
logdir=${trimdir}/log

mkdir -p ${logdir}
mkdir -p ${groupdir}
# dirs=$(ls ${fastadir})


# for dir in ${dirs}; do

        # samples=$(ls ${fastadir}/${dir} | grep -v "Open" | rev | cut -d '.' -f2 | rev | sort -u)

		# echo ${samples}

	# for sample in ${samples}; do

					# echo "sample is ${sample}"

					# name=$(echo ${sample%???})

					# echo "name is ${name}"

					# cat $(find ${fastadir}/* | grep -e ${name} | grep -e "R1") >> ${groupdir}/${name}_R1.will.fastq

					# cat $(find ${fastadir}/* | grep -e ${name} | grep -e "R2") >> ${groupdir}/${name}_R2.will.fastq

					# file1="${groupdir}/${name}_R1.will.fastq"

					# file2="${groupdir}/${name}_R2.will.fastq"

					# echo "file1 is ${file1}, file 2 is ${file2}"  
	# done
# done


files=$(ls ${groupdir}/*_R1.will.fastq | xargs -n 1 basename)

for test in $files ; do
	name=${test%??????????????}

	if [ ! -f "${trimdir}/${name}_R1_trim_paired.fq" ] ; then 
		 echo $test >> ./filestodo
	fi
	 
done
	


echo "${filestodo}"


for file_name in $(cat ./filestodo) ; do
	echo "filename is $filename"

	name=${file_name%??????????????}

	echo "submitting for $name"

	file1="${name}_R1.will.fastq"
			
	file2="${name}_R2.will.fastq" 

	echo "file1 is ${file1}, file 2 is ${file2}"  


	java -jar ${trimmomatic} PE -threads 50 -phred33 -trimlog ${logdir}/${name}_trim.log \
	${groupdir}/${file1} ${groupdir}/${file2} \
	${trimdir}/${name}_R1_trim_paired.fq ${trimdir}/${name}_R1_trim_unpaired.fq \
	${trimdir}/${name}_R2_trim.fq ${trimdir}/${name}_R2_trim_unpaired.fq \
	ILLUMINACLIP:${computedir}/tools/Trimmomatic-0.39/adapters/NEBNext_PE.fa:2:30:10
	
done