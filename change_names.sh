#!/bin/bash
## Usage : change_names.sh <directory>

dir=$1

names_tochange=$(ls ${dir} | grep -e "DRIP-")
for file in $names_tochange; do

    if echo "$file" | grep -e "RNase" | grep -v "S2" ; then
 
        name=$(echo "${file}" | cut -d "-" -f 3-4)
        extension=$(echo "${file}" | rev | cut -d "_" -f 1-3 | rev)

        if echo "${name}" | grep -e "6" ; then
            new_name=$(echo "DRIPembryo2-6hr-IP-RNH_realrep2${extension}")

        elif echo "${name}" | grep -e "10" ; then
            new_name=$(echo "DRIPembryo10-14hr-IP-RNH_realrep2${extension}")

        else 
            new_name=$(echo "problem with name")
        fi
    

    elif echo "$file" | grep -e "RNase" | grep -e "S2" ; then

        extension=$(echo "${file}" | rev | cut -d "_" -f 1-3 | rev)

        new_name=$(echo "DRIPs2cells-IP-RNH_realrep2${extension}")

    fi
    
    if echo "$file" | grep -v "RNase" | grep -v "S2" ; then
 
        name=$(echo "${file}" | cut -d "-" -f 3-4)
        extension=$(echo "${file}" | rev | cut -d "_" -f 1-3 | rev)

        if echo "${name}" | grep -e "6" ; then
            new_name=$(echo "DRIPembryo2-6hr-IP_realrep2${extension}")

        elif echo "${name}" | grep -e "14" ; then
            new_name=$(echo "DRIPembryo10-14hr-IP_realrep2${extension}")

        else 
            new_name=$(echo "problem with name")
        fi
    
        
    elif echo "$file" | grep -v "RNase" | grep -e "S2" ; then

        extension=$(echo "${file}" | rev | cut -d "_" -f 1-3 | rev)

        new_name=$(echo "DRIPs2cells-IP_realrep2${extension}")

    fi 

    echo "changed ${file} to ${new_name}"

    mv ${dir}/${file} ${dir}/${new_name}

done