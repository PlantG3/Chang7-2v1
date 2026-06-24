#!/bin/bash -l
#SBATCH --array=1-863
#SBATCH --mem=8G
#SBATCH --time=3-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=ksu-gen-gpu.q
#SBATCH --gres=gpu:rtx_a4000:1
. "/homes/liu3zhen/anaconda/etc/profile.d/conda.sh"
conda activate plantcad
outdir=3o_caduceus
if [ ! -d $outdir ]; then
	mkdir $outdir
fi
in=`ls -1 2o_split/EMS* | sed -n $SLURM_ARRAY_TASK_ID"p"`
out=${outdir}"/EMS_"$SLURM_ARRAY_TASK_ID
python /bulk/liu3zhen/software+/PlantCaduceus/src/zero_shot_score.py \
    -input $in \
    -output $out \
    -model 'kuleshov-group/PlantCaduceus_l32' \
    -device 'cuda:0'

