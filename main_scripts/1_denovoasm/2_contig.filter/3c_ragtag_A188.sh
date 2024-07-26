#!/bin/bash -l
#SBATCH --job-name=ragtag2v4
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=8g
#SBATCH --time=6-00:00:00
conda activate ragtag
cpu_num=$SLURM_CPUS_PER_TASK
ref=/homes/liu3zhen/references/A188Ref1/genome/A188Ref1.fasta
ctg=../1_hifiasm/Ch7_2.ctg.fasta
output_dir=3o_ragtag-A188Ref1
ragtag.py scaffold $ref $ctg -u -t $cpu_num -o $output_dir --mm2-params '-x asm10'

