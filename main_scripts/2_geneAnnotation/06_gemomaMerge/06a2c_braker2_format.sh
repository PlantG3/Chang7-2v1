#!/bin/bash
#SBATCH --mem=48G
#SBATCH --cpus-per-task=1
#SBATCH --time=6-00:00:00

. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate genepred

module load Java

target_genome=Ch7-2v1.fasta
braker2_annot=../05_braker2/05_RNAseq+protein/braker.sort.gff3

java -jar /homes/liu3zhen/software/gemoma/GeMoMa-1.8.jar CLI AnnotationEvidence \
	outdir=. \
	a=../05_braker2/05_RNAseq+protein/braker.sort.gff3 \
	g=$target_genome \
	ao=true

mv annotation_with_attributes.gff braker2.genes.formatted.gff
	
