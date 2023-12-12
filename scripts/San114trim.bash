#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 4:00:00
#SBATCH --ntasks-per-node=4
#SBATCH -o San114trimallign

#activate conda env
module load anaconda3/2022.10
conda activate genomics

#get in right working directory
cd ../data/rawSeq/San114

#do trimming
trimmomatic PE -threads 4 -phred33 San114_CSFP220005395-1a_HG5M3DSX3_L1_1.fq.gz San114_CSFP220005395-1a_HG5M3DSX3_L1_2.fq.gz ../../trimmedSeq/San114/San114M_forward_paired.fq.gz ../../trimmedSeq/San114/San114M_forward_unpaired.fq.gz ../../trimmedSeq/San114/San114M_reverse_paired.fq.gz ../../trimmedSeq/San114/San114M_reverse_unpaired.fq.gz ILLUMINACLIP:../TruSeq3-PE-2.fa:2:30:7 LEADING:3 TRAILING:3 MINLEN:50
trimmomatic PE -threads 4 -phred33 San114_CSFP220005395-1a_HG5NCDSX3_L1_1.fq.gz San114_CSFP220005395-1a_HG5NCDSX3_L1_2.fq.gz ../../trimmedSeq/San114N/San114N_forward_paired.fq.gz ../../trimmedSeq/San114N/San114N_forward_unpaired.fq.gz ../../trimmedSeq/San114N/San114N_reverse_paired.fq.gz ../../trimmedSeq/San114N/San114N_reverse_unpaired.fq.gz ILLUMINACLIP:../TruSeq3-PE-2.fa:2:30:7 LEADING:3 TRAILING:3 MINLEN:50


