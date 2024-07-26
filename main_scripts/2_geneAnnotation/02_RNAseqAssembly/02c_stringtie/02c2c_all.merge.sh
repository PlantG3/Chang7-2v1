#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=1-00:00:00

. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate genepred

ncpu=$SLURM_CPUS_PER_TASK
tmp_gtf_list=all_gtf_list.txt
out=02c2o_stringtie.g0.merge.gtf

ls -1 *tissue.gtf > $tmp_gtf_list

stringtie --merge \
	-g 0 -f 0.02 -p $ncpu \
	-o $out $tmp_gtf_list

rm $tmp_gtf_list

