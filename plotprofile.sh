#!/bin/bash

dir0=~/computational
matdir=$dir0/rloop/matrix
plotdir=$dir0/rloop/plot

mkdir -p $plotdir

conditions="S2 6 10"

cd $matdir

for file in $(ls *.gz); do
	name=$(echo "$file" | cut -d "." -f1)

	plotProfile -m $file \
	--outFileName $plotdir/${name}_profile.png \
	--perGroup \
	--colors green purple blue red \
	--plotTitle "" \
	--refPointLabel "TSS" \
	-T "${name} read density" \
-z ""

done 
