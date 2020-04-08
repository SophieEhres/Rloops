#!/bin/bash

dir="/Users/ehresms/computational/rloop/trim"

echo $dir

for i in $(ls $dir); do

echo $i
    size=$(du $dir/$i | awk '{print $1}')
    echo "size is $size"
    if [ $size < 500000 ] ; 
    then 
        echo "file is $dir/$i, size is $size"
    fi

done