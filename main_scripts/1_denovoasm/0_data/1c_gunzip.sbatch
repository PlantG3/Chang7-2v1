#!/bin/bash
#SBATCH --array=1-4
#SBATCH --mem-per-cpu=4G
#SBATCH --time=1-00:00:00
#SBATCH --cpus-per-task=1
in=`head -n $SLURM_ARRAY_TASK_ID gzlist | tail -n 1`
out=`echo $in | sed 's/.gz$//g'`
gunzip -c -d $in > $out

