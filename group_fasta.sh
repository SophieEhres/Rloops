#!/bin/bash

exec 2>./bowtie_align_trimmed.log


dir0=~/scratch
genomedir=$dir0/genomes/droso/bowtie
loopdir=$dir0/rloop_2
aligndir=$loopdir/align_trimmed
fastadir=$dir0/rloop/trim
groupdir=$loopdir/grouped_fasta

mkdir $aligndir
mkdir $groupdir

cd $aligndir

dirnames=$(ls $fastadir)

echo "dirnames are $dirnames"

for i in ${dirnames}; do

	samples=$(ls $fastadir/$i | grep -e "paired" | cut -d '_' -f2 | sort -u)
	
	echo "Samples are $samples"
	
	names=$(echo $samples | cut -d '.' -f2)
		

	for name in $names; do
	
		echo "Name is $name"

		files_R1=$(echo $samples | grep -e $name | grep -e "R1")
		files_R2=$(echo $samples | grep -e $name | grep -e "R1")
		cat $files_R1 >> ${groupdir}/${name}_grouped_paired_R1.fasta
		cat $files_R2 >> ${groupdir}/${name}_grouped_paired_R2.fasta
	
		file1=${groupdir}/${name}_grouped_paired_R1.fasta
		file2=${groupdir}/${name}_grouped_paired_R2.fasta
		echo "file1 is $file1, file 2 is $file2"  

		bowtie2 -q -p 12 -x $genomedir/bowtie_droso -1 $fastadir/$i/$file1 -2 $fastadir/$i/$file2 \
			-S ${name}_aligned_rep1.sam
		
done

done
