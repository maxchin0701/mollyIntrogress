#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM-shared
#SBATCH -t 3:00:00
#SBATCH --ntasks-per-node=30
#SBATCH -o processGCNV

#activate conda env
module load anaconda3/2022.10
conda activate gatk

#get into right directory
cd ../gatk-4.1.9.0

#get current sample
curSamp=Amm087;


#process gcnv for sample
./gatk PostprocessGermlineCNVCalls \
        --model-shard-path ../data/gcnv/gcnvAll-model \
        --calls-shard-path ../data/gcnv/gcnvAll-calls \
        --contig-ploidy-calls ../data/ploidy/ploidyALL-calls \
        --sample-index 0 \
        --output-genotyped-intervals ../data/gcnv/$curSamp/$curSamp\GenotypedIntervals.vcf \
        --output-genotyped-segments ../data/gcnv/$curSamp/$curSamp\GenotypedSegments.vcf \
        --output-denoised-copy-ratios ../data/gcnv/$curSamp/$curSamp\CopyRatios.tsv \
        --sequence-dictionary ../data/refGenome/PFo_ref.dict

