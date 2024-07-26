#!/bin/bash
#SBATCH --mem=16G
#SBATCH --time=1-00:00:00

# B73v4
cut -f 1,3,4 2o_ragtag-B73v4/ragtag.scaffold.asm.paf | sort -k1 -k2n,2 > 2o_B73v4.mapped.bed
bedtools coverage -a 1o_ch7-2.ctg.length -b 2o_B73v4.mapped.bed > 2o_B73v4.mapped.contigs.coverages.bed
rm 2o_B73v4.mapped.bed

# B73v5
cut -f 1,3,4 4o_ragtag_output/ragtag.scaffold.asm.paf | sort -k1 -k2n,2 > 4o_B73v5.mapped.bed
bedtools coverage -a 1o_ch7-2.ctg.length -b 4o_B73v5.mapped.bed > 4o_B73v5.mapped.contigs.coverages.bed
rm 4o_B73v5.mapped.bed

# A188
cut -f 1,3,4 3o_ragtag-A188Ref1/ragtag.scaffold.asm.paf | sort -k1 -k2n,2 > 3o_A188.mapped.bed
bedtools coverage -a 1o_ch7-2.ctg.length -b 3o_A188.mapped.bed > 3o_A188.mapped.contigs.coverages.bed
rm 3o_A188.mapped.bed

