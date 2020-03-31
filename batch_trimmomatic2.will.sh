#!/bin/bash

dir0=~/scratch
loopdir=$dir0/new_rloop
fastadir=$dir0/rloop/fasta
groupdir=$loopdir/fasta_grouped
trimdir=$loopdir/trim
trimmomatic=$dir0/tools/Trimmomatic-0.39/trimmomatic-0.39.jar
logdir=$trimdir/log

mkdir -p $logdir
mkdir -p $groupdir
dirs=$(ls $fastadir)

module load java

d=1
n=1

files=$(ls $groupdir/*_R1.will.fastq | xargs -n 1 basename)

echo "$files"

for file_name in $files; do
	name=${file_name::-14}
	echo "submitting for $name"

	file1="${name}_R1.will.fastq"
			
	file2="${name}_R2.will.fastq"

	echo "file1 is ${file1}, file 2 is ${file2}"  

	echo "#!/bin/bash
	module load java

	java -jar ${trimmomatic} PE -threads 50 -phred33 -trimlog ${logdir}/${name}_trim.log \
	${groupdir}/${file1} ${groupdir}/${file2} \
	${trimdir}/${name}_R1_trim_paired.fq ${trimdir}/${name}_R1_trim_unpaired.fq \
	${trimdir}/${name}_R2_trim.fq ${trimdir}/${name}_R2_trim_unpaired.fq \
	ILLUMINACLIP:${dir0}/tools/Trimmomatic-0.39/adapters/NEBNext_PE.fa:2:30:10
	" | sbatch -A def-moroyt -n 12 --time=12:00:00 --mem-per-cpu=20G    
wait 1
done

