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


files=$(ls ${groupdir}/*_R1.will.fastq | xargs -n 1 basename)
cd $groupdir

# for test in $files ; do
	# name=${test%??????????????}

	# if [ -f "${trimdir}/${name}_R1_trim_paired.fq" ] ; then 

		#  tozip1=$(ls $groupdir/*.fastq | xargs -n 1 basename | grep -e $name | grep -e "R1")
		#  tozip2=$(ls $groupdir/*.fastq | xargs -n 1 basename | grep -e $name | grep -e "R2")
		# echo "zipping $tozip1, $tozip2"

		
		# tar -cvzf "${tozip1}.tar.gz" $tozip1
		# tar -cvzf "${tozip2}.tar.gz" $tozip2

	# fi
	 
# done


for test in $files ; do
	zipped="${test}.tar.gz"
	name=${test%??????????????}

	if [ -f "$zipped" ] ; then 

		 zipped1=$(ls $groupdir/*.fastq | xargs -n 1 basename | grep -e $name | grep -e "R1")
		 zipped2=$(ls $groupdir/*.fastq | xargs -n 1 basename | grep -e $name | grep -e "R2")
		
		echo "removing $zipped1, $zipped2"

		
		rm $zipped1
		rm $zipped2
		
	fi
	 
done

cd $computedir/Rloops
