#!/bin/bash
exec 2>./callpeaks.log

dir0="/Users/ehresms/computational"
splitdir="${dir0}/rloop/split_sam"
aligndir="${dir0}/rloop/align"
peakdir="${dir0}/rloop/peaks"

mkdir -p $peakdir

names=$(ls ${splitdir} | rev | cut -d "." -f2  | cut -d "_" -f2- | rev | uniq | grep -v "input" )

for name in ${names}; do

		echo "checking if ${name} peak files exist in peak directory"

		if [ -d "${peakdir}/${name}_forward" ]; then

			echo "peaks already called"

		else

			echo "no peak file found, proceeding to calling peaks for ${name}"

			if echo ${name} | grep -e "RNH" | echo ${name} | grep -e "RNase"; then

				controlname=$(echo ${name} | rev | cut -d "-" -f3- | rev)

			else

				controlname=$(echo ${name} | rev | cut -d "-" -f2- | rev)

			fi


			file_f=$(ls ${splitdir}/*.bam | grep -e ${name} | grep -v "input" | grep -e "forward")
			control_f=$(ls ${splitdir}/*.bam | grep -e ${controlname} | grep -e "input" | grep -v "RNase" | grep -e "forward")

			file_r=$(ls ${splitdir}/*.bam | grep -e ${name} | grep -v "input" | grep -e "reverse")
			control_r=$(ls ${splitdir}/*.bam | grep -e ${controlname} | grep -e "input" | grep -v "RNase" | grep -e "reverse")
			

			macs2 callpeak -t ${file_f} -c ${control_f} \
			--name ${name}_forward --outdir ${peakdir}/${name}_forward \
			--format BAMPE -g 1.2e8 --nomodel -q 0.01 &
			pid_${name}_f=$!

			macs2 callpeak -t ${file_r} -c ${control_r} \
			--name ${name}_reverse --outdir ${peakdir}/${name}_reverse \
			--format BAMPE -g 1.2e8 --nomodel -q 0.01 &
			pid_${name}_r=$!
			

		fi
done

for name in ${names}; do
	
	wait pid_${name}_f && echo " macs2 for ${name}_forward exited normally " || echo " macs2 for ${name}_forward exited abnormally, check callpeaks.log "
	wait pid_${name}_r && echo " macs2 for ${name}_reverse exited normally " || echo " macs2 for ${name}_reverse exited abnormally, check callpeaks.log "

done