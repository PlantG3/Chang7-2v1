#!/bin/bash
#SBATCH --array=1-19
#SBATCH --cpus-per-task=16
#SBATCH --mem=96G
#SBATCH --time=1-00:00:00
#SBATCH --partition=ksu-gen-gpu.q
#SBATCH --gres=gpu:geforce_rtx_2080_ti:4
module load Python/3.9.6-GCCcore-11.2.0
source ~/venvs/esmvar/bin/activate
protein=0_split/Ch7-2prot.${SLURM_ARRAY_TASK_ID}
outdir=1_esm
output=`basename $protein | sed 's/$/.esmvar.csv/g'`
time python3 ~/software/esm-variants/esm_score_missense_mutations.py \
	--input-fasta-file $protein \
	--output-csv-file $outdir/$output

