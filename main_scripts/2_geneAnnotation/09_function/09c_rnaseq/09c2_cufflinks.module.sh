#!/bin/bash
bam=$1
gtf=/bulk/liu3zhen/research/projects/Chang7-2/main_annotation/08_annot/Chang7-2v1a0.1.gtf
out=`echo $bam | sed 's/.*\///g' | sed 's/.R1.pair.Aligned.*//g'`
cufflinks -o $out -p 16 --GTF $gtf $bam

