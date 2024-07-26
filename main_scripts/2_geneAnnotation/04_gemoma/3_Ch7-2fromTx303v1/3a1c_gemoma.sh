#!/bin/bash
#SBATCH --mem=96G
#SBATCH --cpus-per-task=24
#SBATCH --time=6-00:00:00

. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate genepred

module load Java

target_genome=Ch7-2v1.fasta
target_ID=Ch72
reference_genome=Tx303-1.0.fasta
reference_gtf=Tx303-1.0.gtf

java -jar /homes/liu3zhen/software/gemoma/GeMoMa-1.8.jar CLI GeMoMaPipeline \
	threads=24 outdir=. GeMoMa.Score=ReAlign \
	AnnotationFinalizer.r=NO o=true \
	t=$target_genome \
	i=$target_ID \
	GAF.a="pAA>=0.7" \
	a=$reference_gtf \
	g=$reference_genome

