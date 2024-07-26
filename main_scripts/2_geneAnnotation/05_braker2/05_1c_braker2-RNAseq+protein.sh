#!/bin/bash
#SBATCH --cpus-per-task=32
#SBATCH --mem=96G
#SBATCH --time=20-00:00:00

#   5014311  03a1c_brak  wizard24          1 n   8 c    6.45gb/ 96gb  1-20:10:58  COMPLETED

. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate genepred

# not sure what was wrong. Activation of genepred before running this caused errors (No Perl libraries detected)
# specify path to prothint.py
# either by specifiying "export PROTHINT_PATH=/homes/liu3zhen/software/genemark/gmes_linux_64/ProtHint/bin"
# or by adding "--PROTHINT_PATH=/homes/liu3zhen/software/genemark/gmes_linux_64/ProtHint/bin"

ref=/bulk/liu3zhen/research/projects/Chang7-2/data/EDTA/Ch7-2v1.fasta.mod.MAKER.masked
bam=../../01_star/01f_bam_merge2one/01f1o_ch7-2.RNAseq2v1.merge.bam
proteins=../../03_mikado/mikado.proteins.clean.fasta

# protein sequences have "." to indicate stop codons and sequence names contrain space and lengths of sequences
# it seemed this did not interrupt the analysis
# I tried to reformat it by removing "." and simplifying names. Less transcripts were produced.

ncpu=$SLURM_CPUS_PER_TASK

braker.pl \
	--genome=$ref \
	--species="Ch7-2RP" \
	--bam=$bam \
	--prot_seq=$proteins \
	--cores $ncpu \
	--softmasking 1 \
	--overwrite \
	--etpmode \
	--PROTHINT_PATH=/homes/liu3zhen/software/genemark/gmes_linux_64/ProtHint/bin \
	--gff3

#--prg=gth \
#--gth2traingenes \

