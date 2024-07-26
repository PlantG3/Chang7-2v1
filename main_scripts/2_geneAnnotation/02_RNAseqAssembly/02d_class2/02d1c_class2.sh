#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=6-00:00:00

# 5038430  02d1c_clas  warlock05         1 n  16 c    3.11gb/ 64gb    05:27:33  COMPLETED

. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate genepred

bam=../../01_star/01f_bam_merge2one/01f1o_ch7-2.RNAseq2v1.merge.bam
ncpu=$SLURM_CPUS_PER_TASK
out=02d1o_class2.gtf
class=/homes/liu3zhen/software/class2/CLASS-2.1.7/run_class.pl
perl $class \
	-a $bam \
	-o $out \
	-F 0.05 \
	-p $ncpu \
	--verbose \
	--clean

