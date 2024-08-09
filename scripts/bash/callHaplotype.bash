#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 60:00:00
#SBATCH --ntasks-per-node=30
#SBATCH -o callHaps

#activate conda env
module load GATK
module load anaconda3/2022.10
conda activate genomics

#take in argurment for fixed or variable ploidy prior table
ploidy=$1;

#get into right directory
cd ../data/alignedGenomes

for i in  $(ls -d */); do
(	
	#skip poor quality samples
	if [[ "$i" = "San114N/" || "$i" = "San026/" || "$i" = "V088/" ]] ; then
		continue
    fi

	#get current sample
	curSamp=${i::-1}

	#change into directory for current sample
	cd ./$curSamp

	gatk --java-options "-Xms20G -Xmx20G -XX:ParallelGCThreads=2" HaplotypeCaller \
		-R ../../refGenome/PFor.masked.fasta \
		-I ./$curSamp\SortedDupMarked.bam \
		-L ../../refGenome/putIntro$ploidy\.interval_list \
		-O ../../variantCalls/haplotypes/$curSamp\/$curSamp\Introgress$ploidy\.vcf.gz \
		-ERC GVCF \
		--native-pair-hmm-threads 30
	
	cd ..
)
done

#change to haplotype directory
cd ../variantCalls/haplotypes

#collect sample vcf files
gatk GenomicsDBImport \
	-V Amm087/Amm087Introgress$ploidy\.vcf.gz \
	-V Amm090/Amm090Introgress$ploidy\.vcf.gz \
	-V Amm092/Amm092Introgress$ploidy\.vcf.gz \
	-V Amm105/Amm105Introgress$ploidy\.vcf.gz \
	-V San114/San114Introgress$ploidy\.vcf.gz \
	-V V129/V129Introgress$ploidy\.vcf.gz \
	-V Wes109/Wes109Introgress$ploidy\.vcf.gz \
	-V Wes123/Wes123Introgress$ploidy\.vcf.gz \
	--genomicsdb-workspace-path ../genDB$ploidy \
	-L ../../refGenome/putIntro$ploidy\.interval_list



