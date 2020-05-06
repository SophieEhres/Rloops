#!/bin/bash

analyzedir="/Users/ehresms/computational/rloop/analysis"
genome="/Users/ehresms/computational/genomes/droso/fasta/dmel-all-chromosome-r6.32.fasta"

for file in $(ls ${analyzedir}/*.bed); do

    name=$(echo ${file} | xargs basename | cut -d "." -f1 )
    
    echo "finding motifs for ${name}"

    findMotifsGenome.pl ${file} ${genome} ${analyze} ${analyzedir}/${name}_homer \
        -size 200

done