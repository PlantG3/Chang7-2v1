#!/bin/bash

rawgff=1o_Ch72.filt.gff3
prefix=2o_Ch72
newgff=${prefix}.gff
ref=/homes/liu3zhen/references/Ch7-2v1/genome/Ch7-2v1.fasta


# GFF sort
source ~/perl5/perlbrew/etc/bashrc
perl ~/scripts2/maker/gff3sort.pl --chr_order natural $rawgff > ${rawgff}_sort
grep "^#" -v ${rawgff}_sort | cut -f 1 | awk '!seen[$1]++' | awk '{print $1"\t"NR}' > ${rawgff}_contig.order

# load mymaker
. ~/anaconda3/etc/profile.d/conda.sh 
export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
conda activate mymaker

# change names:
map=2o_rename.map
maker_map_ids --prefix Zm00091aa --justify 6 --sort_order ${rawgff}_contig.order ${rawgff}_sort > ${map}.tmp
# change to community standard:
perl /homes/liu3zhen/scripts2/maker/letter2num.replace.pl ${map}.tmp > $map
rm ${map}.tmp

# gff
cp ${rawgff}_sort ${newgff}.tmp
map_gff_ids $map ${newgff}.tmp
#sed 's/;Alias=.*//g' -i ${newgff}.tmp # to rm Alias information
perl /homes/liu3zhen/scripts2/maker/names.correct.pl --gff ${newgff}.tmp > $newgff
gffread $newgff -T -o ${prefix}.gtf
rm ${newgff}.tmp
rm ${rawgff}_sort
rm ${rawgff}_contig.order

# transcript, cds, protein
gffread $newgff -g $ref -w ${prefix}.transcripts.fasta -x ${prefix}.cds.fasta -y ${prefix}.proteins.fasta
# remove the part after a space in names
sed -i 's/ .*//g' ${prefix}.transcripts.fasta
sed -i 's/ .*//g' ${prefix}.cds.fasta
sed -i 's/ .*//g' ${prefix}.proteins.fasta
sed -i 's/\.$//g' ${prefix}.proteins.fasta # remove the stop codon (.)

# cleanup
#rm $rawgff

