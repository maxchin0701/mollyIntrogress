#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 3:00:00
#SBATCH --ntasks-per-node=30
#SBATCH -o ploidyAll

#activate conda env
module load anaconda3/2022.10
conda activate gatk

#get into right directory
cd ../gatk-4.1.9.0

./gatk DetermineGermlineContigPloidy \
  --input ../data/readCounts/Amm087/Amm087Counts.hdf5 \
  --input ../data/readCounts/Amm090/Amm090Counts.hdf5 \
  --input ../data/readCounts/Amm092/Amm092Counts.hdf5 \
  --input ../data/readCounts/Amm105/Amm105Counts.hdf5 \
  --input ../data/readCounts/San026/San026Counts.hdf5 \
  --input ../data/readCounts/San114/San114Counts.hdf5 \
  --input ../data/readCounts/San114N/San114NCounts.hdf5 \
  --input ../data/readCounts/V088/V088Counts.hdf5 \
  --input ../data/readCounts/V129/V129Counts.hdf5 \
  --input ../data/readCounts/Wes109/Wes109Counts.hdf5 \
  --input ../data/readCounts/Wes123/Wes123Counts.hdf5 \
  --output ../data/ploidy \
  --contig-ploidy-priors ../data/ploidy/ploidyProbs.tsv \
  -L ../data/refGenome/PFo10kb.interval_list \
  --interval-merging-rule OVERLAPPING_ONLY \
  --output-prefix ploidyALL

