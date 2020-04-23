#!/bin/bash
exec 2>./bowtie_align_trimmed.log

dir0=~/computational
genomedir=$dir0/genomes/droso/bowtie
loopdir=$dir0/rloop
aligndir=$loopdir/align_trimmed
fastadir=$loopdir/trim

mkdir $aligndir

cd $aligndir

dirnames=$(ls $fastadir)
echo "dirnames are $dirnames"

for dir in ${dirnames}; do
	mkdir $dir

	samples=$(ls $fastadir/$dir | grep -e "paired" | cut -d '_' -f1 | sort -u)
	
	echo "Samples are $samples"

	for name in $samples; do
		
		echo "Name is $name"

		file1=$(ls $fastadir/$dir |grep -e $name |grep -e "R1" )  
		file2=$(ls $fastadir/$dir |grep -e $name |grep -e "R2" )
		echo "file1 is $file1, file 2 is $file2"  

		bowtie2 -q -p 12 -x $genomedir/bowtie_droso -1 $fastadir/$dir/$file1 -2 $fastadir/$dir/$file2 \
			-S $dir/${name}_aligned.sam
	
	done

done
