#!/bin/bash
#SBATCH --mem=48G
#SBATCH --cpus-per-task=1
#SBATCH --time=6-00:00:00

. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate genepred

module load Java

target_genome=Ch7-2v1.fasta
mikado_annot=mikdo.genes.formatted.gff
gemoma_annot=../04_gemoma/1_Ch7-2fromB73v5/final_annotation.gff
braker2_annot=braker2.genes.formatted.gff

java -jar /homes/liu3zhen/software/gemoma/GeMoMa-1.8.jar CLI GAF \
	outdir=. \
	c=0.1 \
	aat=true \
	tf=true \
	p=gemoma w=1.2 g=$gemoma_annot \
	p=mikado w=1.1 g=$mikado_annot \
	p=brake2 w=0.2 g=$braker2_annot

# sort
perl /homes/liu3zhen/software/gff3sort/gff3sort.pl \
	--precise --chr_order natural filtered_predictions.gff > Ch7-2v1.w0.1.gff

# cleanup
rm filtered_predictions.gff

