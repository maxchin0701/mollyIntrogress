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

#take in argurment for fixed or variable ploidy prior table
ploidy=$1;

#call genotypes
gatk GenotypeGVCFs \
	-R ../refGenome/PFor.masked.fasta \
	-V gendb://genDB$ploidy \
	-O ../../outputs/variantCalls/allIntrogress$ploidy\.vcf.gz

cd ../../outputs/variantCalls

#filter vcf
bcftools filter \
	-i 'QUAL>30 && MEAN(FORMAT/DP)>30 && Type="snp" && GT="het"' \
	allIntrogress$ploidy\.vcf.gz | \
	bcftools view -m2 -M2 -q 0.5:minor -v snps -o allIntrogress$ploidy\Filt.vcf.gz


