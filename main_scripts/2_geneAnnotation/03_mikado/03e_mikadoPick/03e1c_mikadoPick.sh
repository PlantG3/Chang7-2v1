#!/bin/bash
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=1G
#SBATCH --time=1-00:00:00

# running information
# 5071191  03e1c_mika  warlock05         1 n  24 c    6.39gb/ 96gb    00:34:50  COMPLETED
# 5195252  03e1c_mika  warlock05         1 n  24 c    6.84gb/ 24gb    00:36:44  COMPLETED

ncpu=8
if [ ! -z $SLURM_CPUS_PER_TASK ]; then
	ncpu=$SLURM_CPUS_PER_TASK
fi

# mikado
. "/homes/liu3zhen/anaconda3/etc/profile.d/conda.sh"
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate mikado

# data
cp ../03b_mikadoPrep/plant.yaml .
cp ../03b_mikadoPrep/configuration.yaml .

if [ -f ../03b_mikadoPrep/mikado_prepared.fasta ]; then
	ln -s ../03b_mikadoPrep/mikado_prepared.fasta .
fi

if [ -f ../03a_dataPrep/Ch7-2v1.fasta ]; then
	ln -s ../03a_dataPrep/Ch7-2v1.fasta .
fi

if [ -f ../03b_mikadoPrep/mikado_prepared.gtf ]; then
	ln -s ../03b_mikadoPrep/mikado_prepared.gtf .
fi

blastxml=../03c_blastx/03c2_blastx/mikado2uniprot.blast.xml
targets=../03c_blastx/03c1_db/uniprot-viridiplantae.fasta
orfs=../03d_transDecoder/mikado_prepared.fasta.transdecoder.bed
junctions=../03a_dataPrep/portcullis_filtered.pass.junctions.bed
genome=../03a_dataPrep/Ch7-2v1.fasta

# Mikado serialise
# This step involves to create a SQLite database
mikado serialise \
   --start-method spawn \
   --procs $ncpu \
   --blast_targets ${targets} \
   --json-conf configuration.yaml \
   --xml ${blastxml} \
   --orfs ${orfs}

# Mikado pick
# to select the best transcript models
mikado pick \
   --start-method spawn \
   --procs $ncpu \
   --json-conf configuration.yaml \
   -od . \
   --subloci-out mikado.subloci.gff3

# output fasta
conda deactivate
conda activate genepred_addition
gffread mikado.loci.gff3 -g ${genome} -t mRNA -x mikado.transcripts.fasta -y mikado.proteins.fasta

