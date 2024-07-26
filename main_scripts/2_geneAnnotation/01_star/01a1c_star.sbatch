#!/bin/bash
#SBATCH --array=1-30
#SBATCH --mem-per-cpu=4g
#SBATCH --time=1-00:00:00
#SBATCH --cpus-per-task=8
in=`sed -n $SLURM_ARRAY_TASK_ID"p" 01a1o_star_1.inlist`
in2=`echo $in | sed 's/R1.fq.gz/R2.fq.gz/g'`
out=`echo $in | sed 's/.*\///g' | sed 's/fastq.gz$//; s/fq.gz$//; s/fastq$//; s/fq$//'`
STAR --readFilesIn $in $in2 --runMode alignReads --readFilesCommand zcat --outSAMtype \
    None --outFilterMismatchNmax 0 --outFilterMismatchNoverLmax 0 --outFilterMatchNmin \
    100 --genomeDir /homes/liu3zhen/references/Ch7-2v1/genome/star/star_noGTF --outFileNamePrefix \
    ./$out

