#!/bin/bash

dir0=~/computational
bamdir=$dir0/rloop/split_sam
wigdir=$dir0/rloop/bigwig

mkdir -p $wigdir

for dir in $(ls $bamdir); do
	for file in $(ls $bamdir/$dir); do
		name=$(echo $file | cut -d "." -f1)
		
		samtools sort -@ 50 \
		-o $bamdir/$dir/${name}_sorted.bam \
		$bamdir/$dir/$file

		samtools index $bamdir/$dir/${name}_sorted.bam

		bamCoverage -b $bamdir/$dir/${name}_sorted.bam \
		-o $wigdir/${name}.bw \
		--normalizeUsing None \
		--smoothLength 300 \
		--extendReads 150 \
		--centerReads \
		-p max/2
	done
done
		
