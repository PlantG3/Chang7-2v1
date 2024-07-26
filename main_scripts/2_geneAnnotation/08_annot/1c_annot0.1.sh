#!/bin/bash
cp ../07_maker/07c_postmaker/3o_tefilt/3_fasta/2o_Ch72.* .
cp ../07_maker/07c_postmaker/3o_tefilt/4_gff/2o_Ch72.clean.gff .
cp ../07_maker/07c_postmaker/3o_tefilt/5_gtf/2o_Ch72.clean.gtf .
rename 2o_Ch72 Chang7-2v1a0.1 2o_Ch72.*
rename .clean "" Chang7-2v1a0.1.*
# change _Txxx to _Pxxx in protein sequences:
sed -i 's/_T/_P/g' Chang7-2v1a0.1.proteins.fasta

