#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 30:00:00
#SBATCH --ntasks-per-node=36
#SBATCH -o align

#activate conda env
module load bedtools
module load GATK
module load anaconda3/2022.10
conda activate genomics

#get into right directory
cd ../data/trimmedSeq

for i in  $(ls -d */); do
(	
	#skip poor quality samples
	if [[ "$i" = "San114N/" || "$i" = "San026/" || "$i" = "V088/" ]] ; then
		continue
    fi

	#get current sample
	curSamp=${i::-1}

	#enter current wd
	cd ./$i

	#clear aligned genome dir
	rm -r ../../alignedGenomes/$curSamp/*

	#unzip .gz files
	#gzip -dk *_paired.fq.gz

	#do alignment
	bwa-mem2 mem -t 36 \
		../../refGenome/PFor.masked.fasta \
		*_forward_paired.fq.gz \
		*_reverse_paired.fq.gz > ../../alignedGenomes/$curSamp/$curSamp\.sam

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

    gatk MarkDuplicatesSpark \
		-I ../../alignedGenomes/$curSamp/$curSamp\Sorted.bam \
		-O ../../alignedGenomes/$curSamp/$curSamp\SortedDupMarked.bam

	#remove unzipped files
	rm -r ../../alignedGenomes/$curSamp/*.sam
	rm -r ../../alignedGenomes/$curSamp/$curSamp\.bam
	rm -r ../../alignedGenomes/$curSamp/$curSamp\Sorted.*

	cd ..
)
done
