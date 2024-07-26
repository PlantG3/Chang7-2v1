#!/bin/bash
#SBATCH --cpus-per-task=24
#SBATCH --mem=96G
#SBATCH --time=6-00:00:00

module load Java
module load BWA
module load SAMtools

draft=`realpath ../../3_contig.filter/7o_Ch7-2.chr.gte25kb.contigs.fasta`
ctglength=chrom.sizes
fq1=`realpath fastq/1884_R1.fastq`
fq2=`realpath fastq/1884_R2.fastq`
outdir=`realpath .`
enzyme=MboI
ncpu=$SLURM_CPUS_PER_TASK
note="Chang7-2 scaffolding"
prefix=Ch7-2

# ref
ref=reference
if [ -d $ref ]; then
	rm -rf $ref
fi
mkdir $ref

cd $ref
ln -s $draft ${prefix}.fasta 
bwa index ${prefix}.fasta
samtools faidx ${prefix}.fasta
cd $outdir

# contig sizes
ln -s $ref/${prefix}.fasta.fai $ctglength
#samtools faidx -o $ctglength $draft

# split reads
if [ -d splits ]; then
	echo "The directory of splits exists."
	rm -rf splits
fi
mkdir splits
cd splits
split -a 3 -l 40000000 -d --additional-suffix=_R1.fastq $fq1
split -a 3 -l 40000000 -d --additional-suffix=_R2.fastq $fq2
cd $outdir

# clean aligned directory
if [ -d aligned ]; then
	rm aligned -rf
fi

# RE sites
RE_dir=restriction_sites
RE_outfile=${prefix}_${enzyme}.txt

if [ -d $RE_dir ]; then
	rm $RE_dir -rf
fi
mkdir $RE_dir

cd $RE_dir
python ~/software/juicer/misc/generate_site_positions.py $enzyme $prefix $draft
RE_data=`realpath $RE_outfile`
cd $outdir

# juicer
sh /homes/liu3zhen/software/juicer/scripts/juicer.sh \
	-q "ksu-plantpath-liu3zhen.q" \
	-l "ksu-plantpath-liu3zhen.q" \
	-D "/homes/liu3zhen/software/juicer" \
	-z $ref/${prefix}.fasta \
	-d $outdir \
	-s $enzyme \
	-t $ncpu \
	-a "$note" \
	-p $ctglength \
	-y $RE_data

