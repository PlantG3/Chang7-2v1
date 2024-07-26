#!/bin/bash
for bam in ../../01_star/01e_bam_mergeByTissue/*bam; do
	sbatch 02c1m_stringtie.sh $bam
done
