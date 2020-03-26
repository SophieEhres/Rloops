#!/bin/bash

dir0=~/computational
genomedir=$dir0/genomes/droso

cd $genomedir

bowtie2-build $(ls $genomedir | tr "\n" ",") \
$genomedir/bowtie_droso \
--threads 8

