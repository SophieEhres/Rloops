#!/bin/bash

analyzedir="/Users/ehresms/computational/rloop/analysis"
genome="/Users/ehresms/computational/genomes/droso/fasta/dmel-all-chromosome-r6.32.fasta"
gtf="/Users/ehresms/computational/genomes/droso/annotations/dmel-all-r6.32.gtf"


for file in $(ls ${analyzedir}/*.bed | grep -e "sensitive"); do

    name=$(echo ${file} | xargs basename | cut -d "." -f1 )
    
    echo "finding motifs for ${name}"

    findMotifsGenome.pl ${file} ${genome} ${analyze} ${analyzedir}/${name}_homertest \
        -size 200 -p 16
    
    annotatePeaks.pl ${file} ${genome} \
        -gtf ${gtf} -raw 
done