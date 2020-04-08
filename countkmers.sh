#!/bin/bash

dir0=~/computational
genomedir=$dir0/genomes/droso/fasta
kmerdir=$dir0/rloop/kmers

mkdir -p $kmerdir

for chr in $(ls $genomedir); do
	name=$(echo $chr | rev | cut -d "." -f1- | rev)

	jellyfish count -m 7 -s 150M -t 12 $genomedir/$chr \
	-o $kmerdir/${name}_7mer.jf
	
	jellyfish dump $kmerdir/${name}_7mer.jf \
	-o $kmerdir/${name}_7mer.table -c
	
done
