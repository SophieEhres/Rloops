#!/bin/bash

exec 2>./bowtie_align_trimmed.log

module load bowtie2

dir0=~/scratch
genomedir=$dir0/genomes/droso/bowtie
loopdir=$dir0/new_rloop
aligndir=$loopdir/align_trimmed
fastadir=$loopdir/trim		

mkdir $aligndir

cd $aligndir

dirnames=$(ls $fastadir)
echo "dirnames are $dirnames"

for i in ${dirnames}; do

	samples=$(ls $fastadir/$i | grep -e "paired" | cut -d '_' -f1 | sort -u)
	
	echo "Samples are $samples"

	for name in $samples; do
		
		echo "Name is $name"

		file1=$(ls $fastadir/$i |grep -e $name |grep -e "R1" |head -n 1)  
		file2=$(ls $fastadir/$i |grep -e $name |grep -e "R2" |head -n 1)
		echo "file1 is $file1, file 2 is $file2"  

		bowtie2 -q -p 12 -x $genomedir/bowtie_droso -1 $fastadir/$i/$file1 -2 $fastadir/$i/$file2 \
			-S ${name}_aligned_rep1.sam
		
		file3=$(ls $fastadir/$i |grep -e $name |grep -e "R1" |tail -n 1) 	
		file4=$(ls $fastadir/$i |grep -e $name |grep -e "R2" |tail -n 1)
		echo "file3 is $file3, file 4 is $file4"
		
		bowtie2 -q -p 12 -x ${genomedir}/bowtie_droso -1 $fastadir/$i/$file3 -2 $fastadir/$i/$file4 \
                        -S ${name}_aligned_rep2.sam
	done

done
