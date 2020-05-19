#!/bin/bash
exec 2>~/computational/scripts/callpeaks.log

dir0="/Users/ehresms/computational"
splitdir="${dir0}/rloop/split_sam"
aligndir="${dir0}/rloop/align"
peakdir="${dir0}/rloop/peaks"

mkdir -p $peakdir

names=$(ls ${splitdir} | cut -d "_" -f1-2 | uniq | grep -v "input" )

for name in ${names}; do

		echo "calling peaks for ${name}"

		controlname=$(echo ${name} | rev | cut -d "-" -f2- | rev)

		file_f=$(ls ${splitdir}/*.bam | grep -e ${name} | grep -v "input" | grep -e "forward")
		control_f=$(ls ${splitdir}*.bam | grep -e ${controlname} | grep -e "input" | grep -v "RNase" | grep -e "forward")

		file_r=$(ls ${splitdir}/*.bam | grep -e ${name} | grep -v "input" | grep -e "reverse")
		control_r=$(ls ${splitdir}*.bam | grep -e ${controlname} | grep -e "input" | grep -v "RNase" | grep -e "reverse")
		
		
		macs2 callpeak -t ${file_f} -c ${control_f} \
		--name ${name}_forward --outdir ${peakdir}/${name}_forward \
		--format BAMPE -g 1.2e8 --nomodel -q 0.01
		
		macs2 callpeak -t ${file_r} -c ${control_r} \
		--name ${name}_reverse --outdir ${peakdir}/${name}_reverse \
		--format BAMPE -g 1.2e8 --nomodel -q 0.01
		
done
