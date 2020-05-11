# Rloops

Steps: 
1. Trim files using trimmomatic: trim_fastq.sh
2. Align files to drosophila genome: bowtie_align.sh
3. Split sam files in forward/reverse: split_sam.sh
4. Generate peak files using MACS2: callpeaks.sh
5. Plot peak profiles using deeptools: computematrix.sh -> plotprofile.sh
6. Merge bed files F/R: bedmerge.sh
7. Differential binding analysis using Diffbind: Dbind.r #Not finished
8. Find motifs and annotate peaks using Homer: homer_findmotifsgenome.sh #Not finished

