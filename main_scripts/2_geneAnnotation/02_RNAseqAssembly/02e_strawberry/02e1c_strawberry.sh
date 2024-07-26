#!/bin/bash
#SBATCH --cpus-per-task=32
#SBATCH --mem=32G
#SBATCH --time=1-00:00:00

# 5038437  02e1c_stra  warlock10         1 n  32 c   19.79gb/512gb    03:15:01  COMPLETED

ref=/bulk/liu3zhen/research/projects/Chang7-2/data/EDTA/Ch7-2v1.fasta.mod.MAKER.masked
bam=../../01_star/01f_bam_merge2one/01f1o_ch7-2.RNAseq2v1.merge.bam
ncpu=$SLURM_CPUS_PER_TASK
out=02e1o_strawberry
strawberry=/homes/liu3zhen/software/strawberry/strawberry

$strawberry \
   --output-dir ${out} \
   --no-quant \
   --num-threads ${ncpu} \
   --min-transcript-size 100 \
   --min-depth-4-transcript 5 \
   --min-support-4-intron 5 \
   --min-exon-cov 3 \
   --min-isoform-frac 0.02 \
   --allow-multimapped-hits \
   ${bam}

