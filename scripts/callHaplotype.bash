#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 10:00:00
#SBATCH --ntasks-per-node=30
#SBATCH -o callHaps

#activate conda env
module load GATK
module load anaconda3/2022.10
conda activate genomics

#get into right directory
cd ../data/alignedGenomes

i=Amm087/;

#get current sample
curSamp=${i::-1}

#change into directory for current sample
cd ./$i

gatk HaplotypeCaller \
	-R ../../refGenome/GCF_000485575.1_Poecilia_formosa-5.1.2_genomic.fna \
	-I ./$curSamp\Sorted.bam \
	-L ../../refGenome/PFo1kb.interval_list \
	-O ../../variantCalls/haplotypes/$curSamp\.vcf.gz \
	-ERC GVCF
