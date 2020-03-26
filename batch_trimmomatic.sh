#!/bin/bash

module load java 
module load trimmomatic

dir0=~/scratch
loopdir=$dir0/new_rloop
fastadir=$dir0/rloop/fasta
trimdir=$loopdir/trim
trimmomatic=$dir0/tools/Trimmomatic-0.39/Trimmomatic-0.39.jar
logdir=$trimdir/log

mkdir -p $logdir


dirs=$(ls $fastadir)

for dir in $dirs; do
	
	cd $fastadir/$dir

	samples=$(ls $fastadir/$dir | rev | cut -d '.' -f2-3 | rev | cut -d '_' -f3-4 | sort -u)
	
	for name in $samples; do
		
		echo "submitteing for $name"

		cat $(ls |grep -e $name |grep -e "R1" | grep -e "HI.4773" ) > ${name}_R1.fastq  
		cat $(ls |grep -e $name |grep -e "R2"  | grep -e "HI.4773" ) > ${name}_R2.fastq
		file1=${name}_R1.fastq 
		file2=${name}_R2.fastq

		echo "file1 is $file1, file 2 is $file2"  
		
		echo "trimming $name \n"

		java -jar -Xmx50g $EBROOTTRIMMOMATIC/trimmomatic-0.36.jar PE -threads 50 -phred33 -trimlog $logdir/${name}_trim.log \
		$fastadir/$dir/$file1 $fastadir/$dir/$file2 \
		$trimdir/${name}_R1_trim_paired.fq $trimdir/${name}_R1_trim_unpaired.fq \
		$trimdir/${name}_R2_trim.fq $trimdir/${name}_R2_trim_unpaired.fq \
		ILLUMINACLIP:$dir0/tools/Trimmomatic-0.39/adapters/NEBNext_PE.fa:2:30:10
	done
done

