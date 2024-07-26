#!/bin/bash
#SBATCH --mem=48G
#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00

. ~/anaconda3/etc/profile.d/conda.sh 
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate mikado

awk '$3=="mRNA"' ../03_mikado/mikado.loci.clean.gff | sed 's/.*\tID=//g' | sed 's/;Parent=/\t/g' | sed 's/;.*//g' > mikado_transcript_genes
mikado util grep mikado_transcript_genes ../03_mikado/mikado.loci.clean.gff | grep "^###" -v | awk '$3!="superlocus"' > mikado.genes.gff

conda deactivate
conda activate genepred

module load Java

target_genome=Ch7-2v1.fasta
mikado_annot=../06_merge/mikado.genes.gff

java -jar /homes/liu3zhen/software/gemoma/GeMoMa-1.8.jar CLI AnnotationEvidence \
	outdir=. \
	a=mikado.genes.gff \
	g=$target_genome \
	ao=true

# rename
mv annotation_with_attributes.gff mikdo.genes.formatted.gff

# cleanup
rm mikado_transcript_genes
rm mikado.genes.gff

