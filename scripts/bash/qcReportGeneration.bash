#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 7:00:00
#SBATCH --ntasks-per-node=2
#SBATCH -o qcReportGeneration

#load FastQC module
module load FastQC

#get into right directory
cd ../data/rawSeq

for i in  $(ls -d */); do
(
	#change into current wd
	cd ./$i

	#unzip .gz files
	gzip -dk *.gz

	#run FastQC
	fastqc -o ../../../outputs/qcReports/$i -t 2 *.fq  

	#delete unzipped files
	rm -r *.fq 

	#return to overall rawSeq dir
	cd ..
)
done

mv qcReportGeneration ./scriptOuts