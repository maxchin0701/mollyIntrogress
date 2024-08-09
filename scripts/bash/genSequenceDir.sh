#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 1:00:00
#SBATCH --ntasks-per-node=2
#SBATCH -o genSeqDir

module load GATK

gatk CreateSequenceDictionary \
		R=../data/refGenome/PFor.masked.fasta \
		O=../data/refGenome/PFor.masked.dict