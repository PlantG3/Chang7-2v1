#!/bin/bash
#SBATCH --cpus-per-task=96
#SBATCH --mem-per-cpu=3G
#SBATCH --time=12-00:00:00

ncpu=$SLURM_CPUS_PER_TASK
prefix=Ch72asm2
fq1=/bulk/liu3zhen/research/projects/Chang7-2/data/hifi/Chang7-2.ccs.1.fastq.gz
fq2=/bulk/liu3zhen/research/projects/Chang7-2/data/hifi/Chang7-2.ccs.2.fastq.gz
fq3=/bulk/liu3zhen/research/projects/Chang7-2/data/hifi/Chang7-2.ccs.3.fastq.gz
fq4=/bulk/liu3zhen/research/projects/Chang7-2/data/hifi/Chang7-2.ccs.4.fastq.gz
hifiasm=/homes/liu3zhen/software/hifiasm/hifiasm_r375/hifiasm
$hifiasm -o ${prefix} -t $ncpu -l0 -n5 $fq1 $fq2 $fq3 $fq4 2>${prefix}.log
awk '/^S/{print ">"$2;print $3}' ${prefix}.bp.p_ctg.gfa > ${prefix}.p_ctg.fasta
perl /homes/liu3zhen/scripts/assembly/seq2summary.pl ${prefix}.p_ctg.fasta > ${prefix}.p_ctg.stat

