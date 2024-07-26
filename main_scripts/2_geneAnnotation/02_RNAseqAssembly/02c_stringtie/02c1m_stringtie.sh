#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=1-00:00:00

. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate genepred

bam=$1
ncpu=$SLURM_CPUS_PER_TASK
prefix=`basename ${bam} | sed 's/.bam//g'`

stringtie \
	${bam} \
	-m 100 \
	-p $ncpu \
	-v \
	-o ${prefix}.tissue.gtf
