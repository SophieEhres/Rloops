#!/bin/bash

dir0="/Users/ehresms/computational"
matdir=${dir0}/rloop/matrix
plotdir=${dir0}/rloop/plot
wigdir=${dir0}/rloop/bigwig

mkdir -p ${plotdir}

TSS=$(ls ${matdir}/*.gz | grep -e "TSS")
mid=$(ls ${matdir}/*.gz | grep -e "reference")



for file in ${TSS}; do
	
	name=$(echo -e ${file} | cut -d "/" -f7 | cut -d "." -f1)
	name_file=$(echo ${name} | cut -d "_" -f1)
	labels=$(ls ${wigdir} | grep -e ${name_file} | grep -e "final" | cut -d "_" -f1-2)

	for label in $labels; do
		echo "${label} " >> ./names.txt
	done

	real_labels=$(cat ./names.txt | tr "\n" " " )


	echo "there are $(cat ./names.txt | wc -l) labels, which are ${real_labels}"


	plotProfile -m ${file} \
	--outFileName ${plotdir}/${name}.svg \
	--plotHeight "10" \
	--plotWidth "20" \
	--perGroup \
	--colors "#ff200f" "#cf2f2f" "#ff9700" "#d3921d" "#87ff00" "#109800" "#127b2a" "#00ffc9" "#6843c5" "#bc94ee" "#0036ff" "#7592fe" "#6843c5" "#6843c5" \
	--plotTitle "peak average coverage around TSS" \
	--legendLocation "lower-left" \
	--plotFileFormat "svg"  
  
  rm ./names.txt

done 



for file in ${mid}; do

	name=$(echo -e ${file} | cut -d "/" -f7 | cut -d "." -f1)
	name_file=$(echo ${name} | cut -d "_" -f1)
	labels=$(ls ${wigdir} | grep -e ${name_file} | grep -e "final" | cut -d "_" -f1-2)

	for label in $labels; do
		echo "label is ${label}"
		echo "\"${label}\"" >> ./names.txt
	done

	real_labels=$(cat ./names.txt | tr "\n" " " )

	plotProfile -m ${file} \
		--outFileName ${plotdir}/${name}.svg \
		--perGroup \
		--colors  "#ff200f" "#cf2f2f" "#ff9700" "#d3921d" "#87ff00" "#109800" "#127b2a" "#00ffc9" "#6843c5" "#bc94ee" "#0036ff" "#7592fe" "#eac2e8" "#6843c5" \
		--plotTitle "peak average coverage around middle of peak" \
		--legendLocation "center-right" \
		--plotFileFormat "svg" \
		--refPointLabel "0" \
		--plotHeight "10" \
		--plotWidth "20" 

	rm ./names.txt 

done