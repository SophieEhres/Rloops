#!/bin/bash

dir0=/Users/ehresms/computational
bamdir=${dir0}/rloop/align
countdir=${dir0}/rloop/counts
gtfdir=${dir0}/rloop/consensus_gtf

mkdir -p ${countdir}

for file in $(ls ${bamdir}/*.bam); do

    echo "counting ${file}"

    name=$(echo ${file%????} | rev | cut -d "/" -f1 | rev)
    
    if echo "checking ${name} annotation" | grep -e "6" ; then
        anno=$(ls ${gtfdir}/*.gtf | grep -e "annotation" | grep -e "both" | grep -e "2_")

    elif echo "checking ${name} annotation" | grep -e "10"; then
        anno=$(ls ${gtfdir}/*.gtf | grep -e "annotation" | grep -e "both" | grep -e "10")

    elif echo "checking ${name} annotation" | grep -e "cells"; then
        anno=$(ls ${gtfdir}/*.gtf | grep -e "annotation" | grep -e "both" | grep -e "cells")

    else
        echo "problem with annotation"
    fi    
        echo "annotation is ${anno}"

    featureCounts -T 16 -p \
        -M --fraction \
        -t "exon" \
        -g "test_id" \
        -s 1 \
        -F GTF \
        -a ${anno} \
        -o ${countdir}/${name} \
        ${file}

done