#!/bin/bash
#SBATCH --array=1-30
#SBATCH --mem-per-cpu=24g
#SBATCH --time=1-00:00:00
#SBATCH --cpus-per-task=16
in=`sed -n $SLURM_ARRAY_TASK_ID"p" 09c1_1o_star.SatSep31239492022.inlist2sbatch.txt`
in2=`echo $in | sed 's/R1.pair.fq/R2.pair.fq/g'`
out=`echo $in | sed 's/.*\///g' | sed 's/fastq$//; s/fq$//'`
STAR --readFilesIn $in $in2 --alignIntronMax 50000 --alignMatesGapMax 30000 --outSAMattrIHstart \
    0 --outSAMmultNmax 1 --outSAMstrandField intronMotif --outFilterIntronMotifs RemoveNoncanonicalUnannotated \
    --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outFilterMismatchNmax \
    2 --outFilterMismatchNoverLmax 0.02 --outFilterMatchNmin 80 --outSJfilterReads Unique \
    --outFilterMultimapNmax 1 --outFilterMultimapScoreRange 2 --outSAMmapqUnique 60 \
    --outFilterMatchNminOverLread 0.98 --genomeDir /homes/liu3zhen/references/Ch7-2v1/genome/star/star_GTF \
    --outFileNamePrefix ./$out

