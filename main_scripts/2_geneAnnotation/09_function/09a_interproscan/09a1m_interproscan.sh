#!/bin/bash

interproscan=/homes/liu3zhen/software/interproscan/interproscan-5.55-88.0/interproscan.sh

ncpus=$1
array_id=$2

prot=09a1_proteinsplit/Ch72prot.${array_id}
out=09a2_interproscan/Ch72prot.${array_id}.interproscan
log=09a2_interproscan/Ch72prot.${array_id}.interproscan.log

sh $interproscan -cpu $ncpus -i $prot -f tsv -o $out -goterms --pathways 1>$log 2>&1

# pfam
#awk '$4 == "Pfam"' $out | cut -f 1 | sort | uniq > ${out}.pfam.transcripts
#awk '$4 == "Pfam"' $out > ${out}.pfam

