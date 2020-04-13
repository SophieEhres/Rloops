#!/bin/bash

dir0="/Users/ehresms/computational"
matdir=$dir0/rloop/matrix
plotdir=$dir0/rloop/plot

mkdir -p $plotdir

conditions="S2 6 10"

TSS=$(ls ${matdir}/*.gz | grep -e "TSS")
mid=$(ls ${matdir}/*.gz | grep -e "mid")


for file in ${TSS}; do
	
	name=$(echo -e ${file} | cut -d "." -f1-2 | cut -d "/" -f7)

	plotProfile -m $file \
	--outFileName $plotdir/${name}_TSS.png \
	--perGroup \
	--colors "#ff200f" "#cf2f2f" "#ff9700" "#d3921d" "#87ff00" "#109800" "#127b2a" "#00ffc9" "#41fed6" "#1d3fee" "#0036ff" "#7592fe" "#a175fe" "#8f00f0" \
	--plotTitle "coverage TSS"
	

done 

for file in ${mid}; do

	name=$(echo -e ${file} | cut -d "." -f1 | cut -d "/" -f7)

	plotProfile -m $file \
		--outFileName $plotdir/${name}_mid.png \
		--perGroup \
		--colors  "#ff200f" "#cf2f2f" "#ff9700" "#d3921d" "#87ff00" "#109800" "#127b2a" "#00ffc9" "#41fed6" "#1d3fee" "#0036ff" "#7592fe" "#a175fe" "#8f00f0" \
		--plotTitle "coverage mid"


done