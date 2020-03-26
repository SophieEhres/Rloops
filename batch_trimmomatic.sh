#!/bin/bash

dir0=~/scratch
loopdir=$dir0/new_rloop
fastadir=$dir0/rloop/fasta
groupdir=$loopdir/fasta_grouped
trimdir=$loopdir/trim
trimmomatic=$dir0/tools/Trimmomatic-0.39/Trimmomatic-0.39.jar
logdir=$trimdir/log

mkdir -p $logdir
mkdir -p $groupdir

dirs=$(ls $fastadir)

for dir in $dirs; do
	
	cd $fastadir/$dir

	samples=$(ls $fastadir/$dir | rev | cut -d '.' -f2-3 | rev | cut -d '_' -f3-4 | sort -u)
	
	for name in $samples; do
		
		echo "submitting for $name"
		
		 export trim_job_${name}=$(echo "#!/bin/bash
  		  #SBATCH --time=12:00:00
		  #SBATCH --job-name=Trimmomatic_${name}
		  #SBATCH --output=%x-%j.out
		  #SBATCH --error %x-%j.err
		  #SBATCH --ntasks=12
		  #SBATCH --mem-per-cpu=2000
		  #SBATCH --mail-user=$JOB_MAIL
		  #SBATCH --mail-type=END, FAIL
		  #SBATCH --A=$SLURM_ACCOUNT
		  
		  module load java
		  module load trimmomatic
		  
		cd $[fastadir}/${dir}
		
		cat $(ls |grep -e $name |grep -e "R1" | grep -e "HI.4773" ) > ${groupdir}/${name}_R1.fastq  
		cat $(ls |grep -e $name |grep -e "R2" | grep -e "HI.4773" ) > ${groupdir}/${name}_R2.fastq
		file1=${groupdir}/${name}_R1.fastq 
		file2=${groupdir}/${name}_R2.fastq

		echo "file1 is ${file1}, file 2 is ${file2}"  
		
		echo "trimming ${name}"

		java -jar -Xmx50g $EBROOTTRIMMOMATIC/trimmomatic-0.36.jar PE -threads 12 -phred33 -trimlog ${logdir}/${name}_trim.log \
		${fastadir}/${dir}/${file1} ${fastadir}/${dir}/${file2} \
		${trimdir}/${name}_R1_trim_paired.fq ${trimdir}/${name}_R1_trim_unpaired.fq \
		${trimdir}/${name}_R2_trim.fq ${trimdir}/${name}_R2_trim_unpaired.fq \
		ILLUMINACLIP:$dir0/tools/Trimmomatic-0.39/adapters/NEBNext_PE.fa:2:30:10 " |
	    sbatch | grep "[0-9]" | cut -d\ -f4)
	
	done
done

