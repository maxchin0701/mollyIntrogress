#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 12:00:00
#SBATCH --ntasks-per-node=4
#SBATCH -o trimReads

#activate conda env
module load anaconda3/2022.10
conda activate genomics

#get into right directory
cd ../data/rawSeq

for i in  $(ls -d */); do
(
	#skip if current directory is San114 (unqique case)
	if [ "$i" = "San114/" ] ; then
        continue
    fi
	#enter current wd
	cd ./$i

	#get current sample
	curSamp=${i::-1}

	#run trimmomatic
	trimmomatic PE -threads 4 -phred33 *1.fq.gz *2.fq.gz ../../trimmedSeq/$curSamp/$curSamp\_forward_paired.fq.gz ../../trimmedSeq/$curSamp/$curSamp\_forward_unpaired.fq.gz ../../trimmedSeq/$curSamp/$curSamp\_reverse_paired.fq.gz ../../trimmedSeq/$curSamp/$curSamp\_reverse_unpaired.fq.gz ILLUMINACLIP:../TruSeq3-PE-2.fa:2:30:7 LEADING:3 TRAILING:3 MINLEN:50

)
done
