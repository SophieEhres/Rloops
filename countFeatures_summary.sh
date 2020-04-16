#!/bin/bash

dir0="/Users/ehresms/computational/rloop"
countdir=${dir0}/counts

echo "merging counts for specific peaks"

for file in $(ls ${countdir}/*.summary | grep -v "all"); do
    echo "getting counts summary for ${file}"
    
    line=$(cat ${file} | awk '{print $2}' | tr "\n" "\t")
    echo "${line}">>counts_summary.tmp
done

first_file=$(ls ${countdir}/*.summary | tr "\n" " " | cut -d " " -f1)

echo "getting names from first file ${first_file}"

header=$(cat ${first_file} | awk '{print $1}' | tr "\n" "\t")

echo -e "${header}" > ${countdir}/counts_summary.tsv 
cat counts_summary.tmp >> ${countdir}/counts_summary.tsv

rm *.tmp


echo "merging counts for all peaks"

for file in $(ls ${countdir}/*.summary | grep -e "all"); do
    echo "getting counts summary for ${file}"
 
    line=$(cat ${file} | awk '{print $2}' | tr "\n" "\t")
    echo "${line}">>counts_summary.tmp
done

first_file=$(ls ${countdir}/*.summary | tr "\n" " " | cut -d " " -f1)

echo "getting names from first file ${first_file}"

header=$(cat ${first_file} | awk '{print $1}' | tr "\n" "\t")

echo -e "${header}" > ${countdir}/counts_allpeaks_summary.tsv 
cat counts_summary.tmp >> ${countdir}/counts_allpeaks_summary.tsv


rm *.tmp

