#!/bin/bash
exec 2>~/computational/scripts/callpeaks_redo.log

dir0=~/computational
splitdir=$dir0/rloop/split_sam
aligndir=$dir0/rloop/align
peakdir=$dir0/rloop/first_peak

mkdir -p $peakdir

for dir in $(ls $splitdir | grep -e "June"); do
	mkdir -p $peakdir/$dir

	files=$(ls $splitdir/$dir | grep -v "input")
	
	for file in $files; do
		control1=$(ls $aligndir/$dir | grep -e "input_aligned_rep1" | grep -v "RNase")
		control2=$(ls $aligndir/$dir | grep -e "input_aligned_rep2" | grep -v "RNase")
		name=$(echo $file | cut -d "." -f1)
		
		macs2 callpeak -t $splitdir/$dir/$file -c $aligndir/$dir/$control1 $aligndir/$dir/$control2 \
		--name $name --outdir $peakdir/$dir/$name \
		--format BAMPE -g 1.2e8 --nomodel 
	done
done
