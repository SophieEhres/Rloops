#!/bin/bash

dir0="/Users/ehresms/computational"
bamdir=${dir0}/rloop/align
countdir=${dir0}/rloop/counts
gtfdir=${dir0}/rloop/consensus_gtf

mkdir -p ${countdir}

anno=$(ls ${gtfdir}/*.gtf | grep -e "both" | grep -e "all" | grep -e "annotation")


for file in $(ls ${bamdir}/*.bam ); do

    name=$(echo ${file%????} | rev | cut -d "/" -f1 | rev)

    echo "counting for ${name}"

    featureCounts -T 16 -p \
        -M --fraction \
        -t "exon" \
        -g "test_id" \
        -s 1 \
        -F GTF \
        -a ${anno} \
        -o ${countdir}/${name}_all.txt \
        ${file}

done