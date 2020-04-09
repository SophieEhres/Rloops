#!/bin/bash

dir0=$computedir
beddir=${dir0}/rloop/consensus_bed
gtfdir=${dir0}/rloop/consensus_gtf
function=${dir0}/tools/bed2gtf/bed2gtf.py

mkdir -p ${gtfdir}

for file in $(ls ${beddir}); do
    echo "processing ${file}"

    name=${file%????}
    python ${function} -i ${beddir}/${file} -o ${gtfdir}/${name}.gtf
done