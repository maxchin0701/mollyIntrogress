#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 30:00:00
#SBATCH --ntasks-per-node=36
#SBATCH -o align

#activate conda env
module load bedtools
module load GATK
module load anaconda3/2022.10
conda activate genomics

#get into right directory
cd ../data/trimmedSeq

for i in  $(ls -d */); do
(	
	#skip poor quality samples
	if [[ "$i" = "San114N/" || "$i" = "San026/" || "$i" = "V088/" ]]; then
		echo $i
	fi
)
done