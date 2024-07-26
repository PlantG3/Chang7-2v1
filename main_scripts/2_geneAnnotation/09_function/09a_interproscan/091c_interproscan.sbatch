#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --array=1-472
#SBATCH --mem-per-cpu=1G
#SBATCH --time=1-00:00:00

module load Java/11.0.2
interproscan=/homes/liu3zhen/software/interproscan/interproscan-5.55-88.0/interproscan.sh
#interproscan=/homes/liu3zhen/software/interproscan/interproscan-5.57-90.0/interproscan.sh
sh 09a1m_interproscan.sh $SLURM_CPUS_PER_TASK $SLURM_ARRAY_TASK_ID
