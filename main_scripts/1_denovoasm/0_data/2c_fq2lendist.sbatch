#!/bin/bash -l
#SBATCH --mem-per-cpu=8G
#SBATCH --time=0-23:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
##SBATCH --partition=ksu-gen-gpu.q,ksu-plantpath-liu3zhen.q,batch.q,killable.q
module load R
Rscript 2c_fq2lendist.R

