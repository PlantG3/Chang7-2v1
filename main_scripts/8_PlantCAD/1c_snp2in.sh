#!/bin/bash
cut -f 2-5 1i_Ch72_EMS.v1.txt > 1i_Ch72_EMS.v1.4cols.txt

# the format of the input file: 1i_Ch72_EMS.v1.4cols.txt
# can be referred to example.snp.input.txt
 
perl snp2in.pl \
  --fas /homes/liu3zhen/references/Ch7-2v1/genome/Ch7-2v1.fasta \
  --snp 1i_Ch72_EMS.v1.4cols.txt \
  > 1o_Ch72_EMS.v1.512bp.context.txt

# cleanup
rm 1i_Ch72_EMS.v1.4cols.txt

