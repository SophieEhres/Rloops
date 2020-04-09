#!/bin/bash

dir0=$computedir
beddir=${dir0}/rloop/consensus_bed
gtfdir=${dir0}/rloop/consensus_gtf
function=${dir0}/tools/bed2gtf/bed2gtf.py

mkdir -p ${gtfdir}

for file in $(ls ${beddir}); do

    echo "processing ${file}"

    name=${file%????}

    if echo "testing ${file} for orientation" | grep -e "reverse" ; then

        python ${function} -i ${beddir}/${file} -o ${gtfdir}/temp.gtf

        awk '{OFS = "\t"} {$7 = "-"; print}' ${gtfdir}/temp.gtf > ${gtfdir}/${name}.gtf

        rm ${gtfdir}/temp.gtf

    else 

        python ${function} -i ${beddir}/${file} -o ${gtfdir}/${name}.gtf

    fi


done

for file in $(ls ${gtfdir}/*_forward.gtf | xargs basename); do
    
    name=${file%????????????}

    echo "concatenating files for ${name}"

    files=$(ls ${gtfdir}/*.gtf | grep -e "${name}" | tr "\n" " ")

    echo "files are ${files}"

    cat $files > ${gtfdir}/${name}_both.gtf

done