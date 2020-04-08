#!/bin/bash

dir0=~/computational
fastadir=$dir0/rloop/fasta
trimdir=$dir0/rloop/trim
trimmomatic=$dir0/tools/Trimmomatic-0.39/Trimmomatic-0.39.jar
logdir=$trimdir/log

mkdir -p $logdir

dirs=$(ls $fastadir)

for dir in $dirs; do
	
	mkdir -p $trimdir/$dir

	samples=$(ls $fastadir/$dir | rev | cut -d '.' -f2-3 | rev | cut -d '_' -f3-4 | sort -u)
	
	for name in $samples; do
		
		echo "Name is $name"

		file1=$(ls $fastadir/$dir |grep -e $name |grep -e "R1" |head -n 1)  
		file2=$(ls $fastadir/$dir |grep -e $name |grep -e "R2" |head -n 1)
		echo "file1 is $file1, file 2 is $file2"  
		
		echo "trimming $name \n"

		java -jar -Xmx50g $trimmomatic PE -threads 50 -phred33 -trimlog $logdir/${name}_trim.log \
		$fastadir/$dir/$file1 $fastadir/$dir/$file2 \
		$trimdir/$dir/${name}_R1_trim_paired.fq $trimdir/$dir/${name}_R1_trim_unpaired.fq \
		$trimdir/$dir/${name}_R2_trim.fq $trimdir/$dir/${name}_R2_trim_unpaired.fq \
		ILLUMINACLIP:$dir0/tools/Trimmomatic-0.39/adapters/NEBNext_PE.fa:2:30:10
	done
done

