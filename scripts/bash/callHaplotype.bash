#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 24:00:00
#SBATCH --ntasks-per-node=30
#SBATCH -o callHaps

#activate conda env
module load GATK
module load anaconda3/2022.10
conda activate genomics

#get into right directory
cd ../data/alignedGenomes

for i in  $(ls -d */); do
(

	#get current sample
	curSamp=${i::-1}

	#change into directory for current sample
	cd ./$curSamp
	
	gatk --java-options "-Xms20G -Xmx20G -XX:ParallelGCThreads=2" HaplotypeCaller \
		-R ../../refGenome/GCF_000485575.1_Poecilia_formosa-5.1.2_genomic.fna \
		-I ./$curSamp\SortedDupMarked.bam \
		-L ../../refGenome/putIntro.interval_list \
		-O ../../variantCalls/haplotypes/$curSamp\/$curSamp\Introgress.vcf.gz \
		-ERC GVCF
	
	cd ..
)
done

#change to haplotype directory
cd ../variantCalls/haplotypes

#collect sample vcf files
gatk GenomicsDBImport \
	-V Amm087/Amm087Introgress.vcf.gz \
	-V Amm090/Amm090Introgress.vcf.gz \
	-V Amm092/Amm092Introgress.vcf.gz \
	-V Amm105/Amm105Introgress.vcf.gz \
	-V San114/San114Introgress.vcf.gz \
	-V V129/V129Introgress.vcf.gz \
	-V Wes109/Wes109Introgress.vcf.gz \
	-V Wes123/Wes123Introgress.vcf.gz \
	--genomicsdb-workspace-path ../genDBAll \
	-L ../../refGenome/putIntro.interval_list



