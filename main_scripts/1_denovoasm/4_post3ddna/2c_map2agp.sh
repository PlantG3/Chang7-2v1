#!/bin/bash
perl ~/scripts2/agp/agp2map.pl ../2_3ddna/4o_juicerbox2/Ch7_2.gte25kb.juicerbox.review.agp | awk '$5>=25000'  > 1i_chr.map
grep -f ../../3_contig.filter/7o_Ch7-2.pMT.contigs ../../3_contig.filter/1o_ch7-2.ctg.length | awk '{if ($3>=25000) { nseq++; print $1"\t+\tpmt"nseq"\t1\t"$3 }}' > 1i_pmt.map
grep -f ../../3_contig.filter/7o_Ch7-2.pPT.contigs ../../3_contig.filter/1o_ch7-2.ctg.length | awk '{if ($3>=25000) { nseq++; print $1"\t+\tppt"nseq"\t1\t"$3 }}' > 1i_ppt.map
perl ~/scripts2/hic/map.update.pl --map 1i_chr.map --map 1i_pmt.map --map 1i_ppt.map --link scaf_chr_link --common scaf > 1o_ch7-2.map

