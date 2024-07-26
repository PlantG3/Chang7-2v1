#!/bin/bash
#SBATCH --cpus-per-task=24
#SBATCH --mem=24G
#SBATCH --time=1-00:00:00

ncpu=$SLURM_CPUS_PER_TASK

. ~/anaconda3/etc/profile.d/conda.sh 
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate tesorter

transcript=2o_Ch72.transcripts.fasta
transcript_pattern="_T[0-9][0-9][0-9]$"
cds=2o_Ch72.cds.fasta
protein=2o_Ch72.proteins.fasta
gff=2o_Ch72.gff
gtf=2o_Ch72.gtf
prefix=3o_tefilt

perl ~/scripts2/tefilt/tefilt.pl \
	--transcript $transcript \
	--tpattern $transcript_pattern \
	--faDB $transcript \
	--faDB $cds \
	--faDB $protein \
	--fnpattern $transcript_pattern \
	--gff $gff \
	--gtf $gtf \
	--prefix $prefix \
	--threads $ncpu

