#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 10:00:00
#SBATCH --ntasks-per-node=30
#SBATCH -o ploidyAll

#activate conda env
module load anaconda3/2022.10
conda activate gatk

#get into right directory
cd ../data/alignedGenomes

for i in  $(ls -d */); do
(
	#get current sample
	curSamp=${i::-1}

	cd ../../gatk-4.1.9.0

	#run DGCP in CASE mode
	./gatk DetermineGermlineContigPloidy \
	  --model ../data/ploidy/ploidyALL-model \
	  --input ../data/readCounts/$curSamp/$curSamp\Counts.hdf5 \
	  --output ../data/ploidy \
	  --output-prefix $curSamp
)
done
