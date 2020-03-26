#!/bin/bash

dir0=~/computational/rloop
aligndir=$dir0/align
splitdir=$dir0/split_sam

for dir in $(ls $aligndir); do
	for file in $(ls $aligndir/$dir | grep "sam"); do
		name=$(echo $file | rev | cut -d '.' -f2 | rev)
		samtools view -b $aligndir/$dir/$file -o $aligndir/$dir/$name.bam -@ 16
		rm $aligndir/$dir/$file
	done
done

for dir in $(ls $splitdir); do
	for file in $(ls $splitdir/$dir | grep "sam"); do
                name=$(echo $file | rev | cut -d '.' -f2 | rev)
                samtools view -b $splitdir/$dir/$file -o $splitdir/$dir/$name.bam -@ 16
		rm $splitdir/$dir/$file
        done

done

