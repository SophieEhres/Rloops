#!/bin/bash

dir0="/Users/ehresms/computational/rloop"
beddir="${dir0}/bed"
mergedir="${dir0}/merged_bed"

mkdir $mergedir

files=$(ls ${beddir} | cut -d "_" -f 1-2 | uniq)

echo "files are $files"

for file in $files; do

    echo "merging for ${file}"

    filestomerge=$(ls ${beddir} | grep -e ${file})

    echo "files to merge are ${filestomerge}"

    for filetomerge in ${filestomerge}; do

        if echo "working on ${filetomerge}" | grep -e "forward"; then
            orient="forward"

        elif echo "working on ${filetomerge}" | grep -e "reverse"; then
            orient="reverse"
        else 
            echo "problem with orientation"
        fi


        file1=$(ls ${beddir} | grep -e "${file}" | grep -e "rep1_" | grep -e ${orient})
        file2=$(ls ${beddir} | grep -e "${file}" | grep -e "rep2_" | grep -e ${orient})
            
        echo "file1 is "${file1}" file2 is "${file2}", end"

        cat ${beddir}/${file1} ${beddir}/${file2} > temp_mergedbed

        sort -k1,1 -k2,2n temp_mergedbed > temp_sorted

        bedtools merge -i temp_sorted > ${mergedir}/${file}_${orient}.merged.bed

    done


   
    rm temp_sorted
    rm temp_mergedbed

done

    
