#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=96G
#SBATCH --time=3-00:00:00

# 5038074  02a1c_port  wizard24          1 n  16 c   33.90gb/ 96gb    02:10:41  COMPLETED

. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate genepred_addition

ref=/homes/liu3zhen/references/Ch7-2v1/genome/Ch7-2v1.fasta
bam=/bulk/liu3zhen/research/projects/Chang7-2/main_annotation/01_star/01e_bam_mergeByTissue/*bam
ncpu=$SLURM_CPUS_PER_TASK
out=02a1o_portcullis
portcullis full \
	--strandedness unstranded \
	--orientation FR \
	--max_length 300000 \
	--min_cov 10 \
	-o $out \
	-t $ncpu \
	--use_csi \
	--force \
	$ref $bam

