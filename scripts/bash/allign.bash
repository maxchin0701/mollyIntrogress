#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 24:00:00
#SBATCH --ntasks-per-node=36
#SBATCH -o allign

#activate conda env
module load bedtools
module load GATK
module load anaconda3/2022.10
conda activate genomics

#get into right directory
cd ../data/trimmedSeq

for i in  $(ls -d */); do
(
	#get current sample
	curSamp=${i::-1}

	#enter current wd
	cd ./$i

	#unzip .gz files
	gzip -dk *_paired.fq.gz

	#do alignment
	bwa-mem2 mem -t 36 \
		../../refGenome/GCF_000485575.1_Poecilia_formosa-5.1.2_genomic.fna \
		*_forward_paired.fq \
		*_reverse_paired.fq > ../../alignedGenomes/$curSamp/$curSamp\.sam

	#convert sam to bam
	gatk SamFormatConverter -I ../../alignedGenomes/$curSamp/$curSamp\.sam \
		-O ../../alignedGenomes/$curSamp/$curSamp\.bam

	#add read groups to bam
	gatk AddOrReplaceReadGroups \
        I=../../alignedGenomes/$curSamp/$curSamp\.bam \
        O=../../alignedGenomes/$curSamp/$curSamp\Sorted.bam \
        RGID=group$curSamp \
        RGLB= lib$curSamp \
        RGPL=illumina \
        RGPU=unit$curSamp \
        RGSM=$curSamp \
        SORT_ORDER=coordinate \
    	CREATE_INDEX=true	

	#remove unzipped files
	rm -r ../../alignedGenomes/$curSamp/*.sam
	rm -r ../../alignedGenomes/$curSamp/$curSamp\.bam
	rm -r *.fq

	cd ..
)
done
