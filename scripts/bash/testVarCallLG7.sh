#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 72:00:00
#SBATCH --ntasks-per-node=4
#SBATCH -o testVarCallLG7-%j

#activate conda env
module load GATK
module load anaconda3/2022.10
conda activate genomics

#get into right directory
cd ../data/alignedGenomes

#get current sample
curSamp=$1

#change into directory for current sample
cd ./$curSamp

gatk --java-options "-Xms20G -Xmx20G -XX:ParallelGCThreads=2" HaplotypeCaller \
	-R ../../refGenome/PFor.masked.fasta \
	-I ./$curSamp\SortedDupMarked.bam \
	-L ../../refGenome/PFo1kbLG7.interval_list \
	-O ../../variantCalls/haplotypes/$curSamp\/$curSamp\IntrogressLG7.vcf.gz \
	-ERC GVCF	

cd ..
