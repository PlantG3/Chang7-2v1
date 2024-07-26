#!/bin/bash
gff=../../08_annot/Chang7-2v1a0.1.gff
awk '$3=="gene"' $gff \
	| cut -f 1,4,5,7,9 | sed 's/ID=//g' \
	| sed 's/;Name.*//g' > Chang7-2v1a0.1.genes


