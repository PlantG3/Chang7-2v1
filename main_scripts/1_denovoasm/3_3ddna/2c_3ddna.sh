#!/bin/bash
#SBATCH --cpus-per-task=96
#SBATCH --mem=96G
#SBATCH --time=6-00:00:00

#conda activate 3ddna

draft=`realpath ../../3_contig.filter/7o_Ch7-2.chr.gte25kb.contigs.fasta`
juicer_aln=`realpath ../1_juicer/aligned/merged_nodups.txt`
output=1o_3ddna
asm=Ch7_2.ctg.fasta

if ! [ -d $output ]; then
	mkdir $output
fi
cd $output

# wrap fasta
awk -f /homes/liu3zhen/software/3d-dna/utils/wrap-fasta-sequence.awk $draft > $asm

bash /homes/liu3zhen/software/3d-dna/run-asm-pipeline.sh \
	-r 0 -q 10 $asm $juicer_aln

cd ..

