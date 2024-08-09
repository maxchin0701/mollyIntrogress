#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 1:00:00
#SBATCH --ntasks-per-node=20
#SBATCH -o indexRef

#activate conda env
module load anaconda3/2022.10
conda activate genomics

#get into right directory
cd ../data/refGenome

#index genome file
bwa-mem2 index PFor.masked.fasta
