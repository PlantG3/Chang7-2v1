#!/bin/bash
#SBATCH --mem=48G
#SBATCH --cpus-per-task=1
#SBATCH --time=6-00:00:00

. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate genepred

module load Java

target_genome=Ch7-2v1.fasta
annot_B73=../1_Ch7-2fromB73v5/final_annotation.gff
annot_P39=../2_Ch7-2fromP39v1/final_annotation.gff
annot_Tx303=../3_Ch7-2fromTx303v1/final_annotation.gff
annot_M37W=../4_Ch7-2fromM37Wv1/final_annotation.gff
annot_NC350=../5_Ch7-2fromNC350v1/final_annotation.gff

java -jar /homes/liu3zhen/software/gemoma/GeMoMa-1.8.jar CLI GAF \
	outdir=. \
	p=B73 w=1 g=$annot_B73 \
	p=P39 w=0.9 g=$annot_P39 \
	p=Tx303 w=0.9 g=$annot_Tx303 \
	p=M37W w=0.9 g=$annot_M37W \
	p=NC350 w=0.9 g=$annot_NC350

