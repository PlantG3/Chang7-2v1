#!/bin/bash

# filter to have good-evidence genes
awk '{ if (NR==1 || $2=="maker") print }' ../07b_maker/Ch72.maker.output/Ch72.all.makerOnly.gff3 > Ch72.all.makerOnly.clean.gff3
perl ~/scripts2/maker/quality_filter_Liu.pl -s -a 0.75 Ch72.all.makerOnly.clean.gff3 > 1o_Ch72.filt.gff3
rm Ch72.all.makerOnly.clean.gff3

#. ~/anaconda3/etc/profile.d/conda.sh 
#export PATH="/homes/liu3zhen/anaconda3/bin:$PATH"
#conda activate tesorter


