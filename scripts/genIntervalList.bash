#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 2:00:00
#SBATCH --ntasks-per-node=2
#SBATCH -o genIntervalList

module load GATK

gatk BedToIntervalList I=../data/refGenome/PFo10kb.bed \
	O=../data/refGenome/PFo10kb.interval_list \
	SD=../data/refGenome/PFo_ref.dict

gatk BedToIntervalList I=../data/refGenome/PFo1kb.bed \
	O=../data/refGenome/PFo1kb.interval_list \
	SD=../data/refGenome/PFo_ref.dict

