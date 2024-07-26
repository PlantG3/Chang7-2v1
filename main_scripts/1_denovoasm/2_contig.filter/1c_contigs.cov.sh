#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=256G
#SBATCH --time=6-00:00:00
bam1=../2_Illumia/2e_aln/ch7-2leaf.bam
bam2=../2_Illumia/2e_aln/ch7-2ie.bam
contig_bed=1o_ch7-2.ctg.length
out=1o_ch7-2leaf_ie.cov
perl ~/scripts/fasta/fastaSize.pl ../1_hifiasm/Ch7_2.ctg.fasta | sort -k2n | awk '{ print $1"\t"0"\t"$2 }' > $contig_bed
bedtools multicov -bams $bam1 $bam2 -bed $contig_bed > $out

