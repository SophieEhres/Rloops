#!/bin/bash

dir0=~/computational
peakdir=$dir0/rloop/first_peak
gtfdir=$dir0/rloop/gtf

mkdir -p $gtfdir

for dir in $(ls $peakdir); do
	files=$(ls $peakdir/$dir | cut -d "_" -f1-3 | uniq)
	
	for file in $files; do
		forwardfile=$(ls $peakdir/$dir | grep -e "$file" | grep -e "forward")
		reversefile=$(ls $peakdir/$dir | grep -e "$file" | grep -e "reverse")
		
		cat $peakdir/$dir/$forwardfile/${forwardfile}_peaks.xls | \
		awk 'BEGIN {OFS="\t"} {print $1,"DRIP","peak",$2,$3,$9,"+",".","."}' >> $gtfdir/$file.gtf
		cat $peakdir/$dir/$reversefile/${reversefile}_peaks.xls | \
		awk 'BEGIN {OFS="\t"} {print $1,"DRIP","peak",$2,$3,$9,"-",".","."}' >> $gtfdir/$file.gtf
	done
done
