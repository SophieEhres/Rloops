#!/bin/bash

dir0=~/computational
peakdir=$dir0/rloop/first_peak
beddir=$dir0/rloop/bed

mkdir -p $beddir

for dir in $(ls $peakdir); do
	files=$(ls $peakdir/$dir | cut -d "_" -f1-3 | uniq)
	
	for file in $files; do
		forwardfile=$(ls $peakdir/$dir | grep -e "$file" | grep -e "forward")
		reversefile=$(ls $peakdir/$dir | grep -e "$file" | grep -e "reverse")
		
		cat $peakdir/$dir/$forwardfile/${forwardfile}_peaks.xls | tail -n+30 | \
		awk 'BEGIN {OFS="\t"} {print $1,$2,$3,$10,$9}' >> $beddir/${file}_forward.bed
		cat $peakdir/$dir/$reversefile/${reversefile}_peaks.xls | tail -n+30 | \
		awk 'BEGIN {OFS="\t"} {print $1,$2,$3,$10,$9}' >> $beddir/${file}_reverse.bed
	done
done
