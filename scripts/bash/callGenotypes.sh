#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 2:00:00
#SBATCH --ntasks-per-node=20
#SBATCH -o callGeno

#activate conda env
module load GATK
module load anaconda3/2022.10
conda activate genomics
module load bcftools

#get into right directory
cd ../data/variantCalls

#call genotypes
gatk GenotypeGVCFs \
	-R ../refGenome/GCF_000485575.1_Poecilia_formosa-5.1.2_genomic.fna \
	-V gendb://genDBAll \
	-O ../../outputs/variantCalls/allIntrogress.vcf.gz

cd ../../outputs/variantCalls

#filter vcf
bcftools filter \
	-i 'QUAL>30 && MEAN(FORMAT/DP)>5 && Type="snp" && GT="het"' \
	allIntrogress.vcf.gz | \
	bcftools view -m2 -M2 -q 0.5:minor -v snps -o allIntrogressFilt.vcf.gz


