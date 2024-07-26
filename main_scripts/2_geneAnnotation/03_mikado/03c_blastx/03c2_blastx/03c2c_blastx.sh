#!/bin/bash
#SBATCH --cpus-per-task=64
#SBATCH --mem-per-cpu=1G
#SBATCH --time=1-00:00:00

# run information
# 5056086  03c2c_blas  warlock05         1 n  64 c   20.16gb/ 64gb    15:32:01  COMPLETED

#. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
#export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
#conda activate mikado

input=../../03b_mikadoPrep/mikado_prepared.fasta
output=mikado2uniprot
db=../03c1_db/uniprot-viridiplantae.fasta
blastx -max_target_seqs 5 -num_threads 8 \
	-query ${input} -outfmt 5 \
	-db ${db} -evalue 0.000001 \
	2> ${output}.log | sed '/^$/d' | \
	gzip -c - > ${output}.blast.xml.gz

gunzip ${output}.blast.xml.gz

