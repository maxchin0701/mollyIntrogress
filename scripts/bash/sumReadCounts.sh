#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 10:00:00
#SBATCH --ntasks-per-node=10
#SBATCH -o sumarizeReadCounts

#activate conda env
module load GATK
module load anaconda3/2022.10
conda activate genomics

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

	#get into current working directory
	cd ..

	#remove existing read counts
	rm -r ./readCounts/$curSamp/$curSamp\Counts10kb.hdf5
	rm -r ./readCounts/$curSamp/$curSamp\Counts1kb.hdf5

	gatk CollectReadCounts \
		-I ./alignedGenomes/$curSamp/$curSamp\SortedDupMarked.bam \
		-L ./refGenome/PFo10kb.interval_list \
		--interval-merging-rule OVERLAPPING_ONLY \
		-O ./readCounts/$curSamp/$curSamp\Counts10kb.hdf5

	gatk CollectReadCounts \
		-I ./alignedGenomes/$curSamp/$curSamp\SortedDupMarked.bam \
		-L ./refGenome/PFo1kb.interval_list \
		--interval-merging-rule OVERLAPPING_ONLY \
		-O ./readCounts/$curSamp/$curSamp\Counts1kb.hdf5


	cd ./alignedGenomes
)
done



