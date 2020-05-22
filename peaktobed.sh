#!/bin/bash

dir0="/Users/ehresms/computational"
peakdir=${dir0}/rloop/peaks
beddir=${dir0}/rloop/bed

mkdir -p ${beddir}

for dir in $(ls ${peakdir}); do
		
		cat $peakdir/$dir/*_peaks.xls | tail -n+30 | \
		awk 'BEGIN {OFS="\t"} {print $1,$2,$3,$10,$9}' >> $beddir/${dir}.bed
	
done


