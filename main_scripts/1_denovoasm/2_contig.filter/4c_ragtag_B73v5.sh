#!/bin/bash -l
#SBATCH --job-name=ragtag2v5
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=5g
#SBATCH --time=6-00:00:00
conda activate ragtag
cpu_num=$SLURM_CPUS_PER_TASK
ref=/homes/liu3zhen/references/B73Ref5/genome/B73Ref5.fasta
ctg=../1_hifiasm/Ch7_2.ctg.fasta
ragtag.py scaffold $ref $ctg -u -t $cpu_num

