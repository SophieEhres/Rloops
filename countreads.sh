#!/bin/bash

dir0=${computational}
bamdir=${dir0}/rloop/align
countdir=${dir0}/rloop/counts
gtfdir=${dir0}/rloop/gtf

mkdir -p ${countdir}

for file in $(ls ${bamdir}); do

    echo "counting ${file}"

    name=$(echo ${file} | cut -d "_" -f1)
    anno=$(ls ${gtfdir} | grep -e "${name}")

    countFeatures -T 16 -a ${gtfdir}/${anno} \
        -p -F -G -M --fraction \
        -o ${countdir}/${name} \
        ${file}

done