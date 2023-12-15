#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 6:00:00
#SBATCH --ntasks-per-node=20
#SBATCH -o markDuplicates

#load GATK and conda
module load GATK
module load anaconda3/2022.10
conda activate genomics

#get into right directory
cd ../data/alignedGenomes

for i in  $(ls -d */); do
(

	#get current sample
	curSamp=${i::-1}

	cd ./$i

	gatk MarkDuplicatesSpark \
		-I ./$curSamp\Sorted.bam \
		-O ./$curSamp\SortedDupMarked.bam

)
done