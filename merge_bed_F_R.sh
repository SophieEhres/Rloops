#!/bin/bash

dir0="/Users/ehresms/computational/rloop"
beddir="${dir0}/bed"
mergedir="${dir0}/F_R_mergedbed"

mkdir $mergedir

files=$(ls ${beddir}| rev | cut -d "_" -f 2- | rev | uniq)

echo "files are $files"

for file in $files; do

    echo "merging for ${file}"

        file1=$(ls ${beddir} | grep -e "${file}" | grep -e "forward")
        file2=$(ls ${beddir} | grep -e "${file}" | grep -e "reverse")
            
        echo "file1 is "${file1}" file2 is "${file2}""

        cat ${beddir}/${file1} ${beddir}/${file2} > ${mergedir}/${file}.mergedFR.bed
        


done

    
