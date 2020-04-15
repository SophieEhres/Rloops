#!/bin/bash

dir0="/Users/ehresms/computational/rloop"
gtfdir=${dir0}/consensus_gtf

for file in $(ls ${gtfdir}/*.gtf | grep -e "both" | grep -v "anno"); do

    name=$(echo ${file%????} | rev | cut -d "/" -f1 | rev)

    # (echo -e "chr\tsource\tfeature\tstart\tstop\tsource\tstrand\tframe\tattribute") > ${gtfdir}/annotation_${name}.tmp
    cat ${file} >> ${gtfdir}/annotation_${name}.tmp

    cat ${gtfdir}/annotation_${name}.tmp | sed 's/peak/exon/'> ${gtfdir}/annotation_${name}2.tmp
    cat ${gtfdir}/annotation_${name}.tmp | awk 'OFS="\t" {$9=$9 ; print}' > ${gtfdir}/annotation_${name}.tmp
    cat ${gtfdir}/annotation_${name}2.tmp | sed 's/peak_id/test_id/' | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9" "$10}'> ${gtfdir}/annotation_${name}.gtf
    rm ${gtfdir}/*.tmp

    echo "head of ${name} is $(head ${gtfdir}/annotation_${name}.gtf)"

done
