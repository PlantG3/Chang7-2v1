#!/bin/bash
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=3G
#SBATCH --time=6-00:00:00

# running information
# 5057328  03d1c_tran  wizard25          1 n  24 c   13.91gb/ 72gb    02:42:33  COMPLETED

ncpu=$SLURM_CPUS_PER_TASK

. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate mikado

in=../03b_mikadoPrep/mikado_prepared.fasta
fas=`basename ${in}`
echo ${fas}
if [ ! -f ${fas} ]; then
	ln -s ${fas} .
fi

TransDecoder.LongOrfs -t ${fas}

TransDecoder.Predict -t ${fas} --cpu $ncpu

