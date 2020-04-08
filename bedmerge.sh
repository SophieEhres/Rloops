#!/bin/bash

dir0="~/computational/rloop"
beddir="${dir0}/consensus_bed"
mergedir="${dir0}/merged_bed"

mkdir $mergedir

for i in $(ls $beddir); do
		
