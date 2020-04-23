#!/bin/bash

dir=$1
if [ "${dir: -1}" == "/" ]; then
    dir=${dir::-1}
fi

echo "directory to change is ${dir}"

files=$(ls -p ${dir} | grep -v "/")
unique_files=$(ls -p ${dir} | grep -v "/" | cut -d "-" -f1-3 | uniq | tr "\n" " ")


echo "files to merge are ${files}"
echo "unique file names are ${unique_files}"

# for unique_file in ${unique_files}; do
#     files_tomerge=$(ls ${dir}/*.bam | grep -e ${unique_file} | tr "\n" " ")
#     echo "files to merge are ${files_tomerge}"
# done