#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 30:00:00
#SBATCH --ntasks-per-node=30
#SBATCH -o gCNVAll

#activate conda env
module load anaconda3/2022.10
conda activate gatk

#get into right directory
cd ../gatk-4.1.9.0

#run 10kb intervals
./gatk GermlineCNVCaller \
  --run-mode COHORT \
  -L ../data/refGenome/PFo10kb.interval_list \
  --interval-merging-rule OVERLAPPING_ONLY \
  --contig-ploidy-calls ../data/ploidy/ploidyALL-calls \
  --input ../data/readCounts/Amm087/Amm087Counts10kb.hdf5 \
  --input ../data/readCounts/Amm090/Amm090Counts10kb.hdf5 \
  --input ../data/readCounts/Amm092/Amm092Counts10kb.hdf5 \
  --input ../data/readCounts/Amm105/Amm105Counts10kb.hdf5 \
  --input ../data/readCounts/San026/San026Counts10kb.hdf5 \
  --input ../data/readCounts/San114/San114Counts10kb.hdf5 \
  --input ../data/readCounts/San114N/San114NCounts10kb.hdf5 \
  --input ../data/readCounts/V088/V088Counts10kb.hdf5 \
  --input ../data/readCounts/V129/V129Counts10kb.hdf5 \
  --input ../data/readCounts/Wes109/Wes109Counts10kb.hdf5 \
  --input ../data/readCounts/Wes123/Wes123Counts10kb.hdf5 \
  --output ../data/gcnv/10kb \
  --output-prefix gcnvAll

#run 11kb intervals
./gatk GermlineCNVCaller \
  --run-mode COHORT \
  -L ../data/refGenome/PFo1kb.interval_list \
  --interval-merging-rule OVERLAPPING_ONLY \
  --contig-ploidy-calls ../data/ploidy/ploidyALL-calls \
  --input ../data/readCounts/Amm087/Amm087Counts1kb.hdf5 \
  --input ../data/readCounts/Amm090/Amm090Counts1kb.hdf5 \
  --input ../data/readCounts/Amm092/Amm092Counts1kb.hdf5 \
  --input ../data/readCounts/Amm105/Amm105Counts1kb.hdf5 \
  --input ../data/readCounts/San026/San026Counts1kb.hdf5 \
  --input ../data/readCounts/San114/San114Counts1kb.hdf5 \
  --input ../data/readCounts/San114N/San114NCounts1kb.hdf5 \
  --input ../data/readCounts/V088/V088Counts1kb.hdf5 \
  --input ../data/readCounts/V129/V129Counts1kb.hdf5 \
  --input ../data/readCounts/Wes109/Wes109Counts1kb.hdf5 \
  --input ../data/readCounts/Wes123/Wes123Counts1kb.hdf5 \
  --output ../data/gcnv/1kb \
  --output-prefix gcnvAll