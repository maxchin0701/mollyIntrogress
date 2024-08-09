#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 2:00:00
#SBATCH --ntasks-per-node=2
#SBATCH -o genIntervalList

module load GATK

bedFile=$1;

gatk BedToIntervalList I=../data/refGenome/$bedFile\.bed \
	O=../data/refGenome/$bedFile\.interval_list \
	SD=../data/refGenome/PFor.masked.dict


