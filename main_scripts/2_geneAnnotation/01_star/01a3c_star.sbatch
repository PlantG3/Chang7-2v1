#!/bin/bash
#SBATCH --array=1-30
#SBATCH --mem-per-cpu=3g
#SBATCH --time=1-00:00:00
#SBATCH --cpus-per-task=16
in=`sed -n $SLURM_ARRAY_TASK_ID"p" 01a1i_star_1.inlist`
all_pass_SJ=../01a_starNoGTF/01a2o_SJ.all.gte10
ref_db=/homes/liu3zhen/references/Ch7-2v1/genome/star/star_noGTF

in2=`echo ${in} | sed 's/.R1.pair.fq.gz/.R2.pair.fq.gz/g'`
out=`echo ${in} | sed 's/.*\///g' | sed 's/fastq.gz$//; s/fq.gz$//; s/fastq$//; s/fq$//'`
STAR --readFilesIn ${in} ${in2} \
	--runMode alignReads \
	--readFilesCommand zcat \
	--outSAMtype BAM SortedByCoordinate \
	--outSAMattributes All \
	--outSAMmapqUnique 10 \
	--sjdbFileChrStartEnd ${all_pass_SJ} \
	--outFilterMismatchNmax 0 \
	--outSAMattrIHstart 0 \
	--outFilterMismatchNoverLmax 0 \
	--outFilterMatchNminOverLread 0.99 \
	--outFilterMatchNmin 100 \
	--genomeDir ${ref_db} \
	--outSAMstrandField intronMotif \
	--outFileNamePrefix ./${out}

#--outWigType bedGraph read1_5p \
#For unstranded RNA-seq data, Cufflinks/Cuffdiff require spliced alignments with XS strand attribute,
#which STAR will generate with --outSAMstrandField intronMotif option.

