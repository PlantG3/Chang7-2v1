#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=6-00:00:00

# 5038427  02b1c_cuff  wizard24          1 n  16 c   11.35gb/512gb    12:32:47  COMPLETED

. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate genepred_addition

ref=/bulk/liu3zhen/research/projects/Chang7-2/data/EDTA/Ch7-2v1.fasta.mod.MAKER.masked
bam=../../01_star/01f_bam_merge2one/01f1o_ch7-2.RNAseq2v1.merge.bam
ncpu=$SLURM_CPUS_PER_TASK
out=02b1o_cufflinks
cufflinks \
	--output-dir . \
	--num-threads $ncpu \
	--library-type fr-unstranded \
	--frag-len-mean 350 \
	--verbose \
	--no-update-check \
	${bam}

