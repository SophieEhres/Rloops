#!/bin/bash

dir0=~/computational/rloop
aligndir=$dir0/align
splitdir=$dir0/split_sam

dirs=$(ls $aligndir)

mkdir $splitdir

for dir in $dirs; do
	files=$(ls $aligndir/$dir)
	targetdir=$splitdir/$dir
	mkdir $targetdir

	for file in $files; do
		name=$(echo $file | cut -d '.' -f1)
		samtools view -h -f 18 $aligndir/$dir/$file > $targetdir/${name}_reverse.sam
		samtools view -h -f 34 $aligndir/$dir/$file > $targetdir/${name}_forward.sam
		
	done
done
