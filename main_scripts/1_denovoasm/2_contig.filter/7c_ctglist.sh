#!/bin/bash
# chromosomes
grep -e "^contig" -e pMT -e pPT 6o_Ch2.contigs.db -v | cut -f 1 > 7o_Ch7-2.chr.contigs
grep -e "^contig" -e pMT -e pPT 6o_Ch2.contigs.db -v | awk '$2>=25000' | cut -f 1 > 7o_Ch7-2.chr.gte25kb.contigs
seqtk subseq ../1_hifiasm/Ch7_2.ctg.fasta 7o_Ch7-2.chr.gte25kb.contigs > 7o_Ch7-2.chr.gte25kb.contigs.fasta

# pMT
grep -e pMT 6o_Ch2.contigs.db | cut -f 1 > 7o_Ch7-2.pMT.contigs
seqtk subseq ../1_hifiasm/Ch7_2.ctg.fasta 7o_Ch7-2.pMT.contigs > 7o_Ch7-2.pMT.contigs.fasta

# pPT
grep -e pPT 6o_Ch2.contigs.db | cut -f 1 > 7o_Ch7-2.pPT.contigs
seqtk subseq ../1_hifiasm/Ch7_2.ctg.fasta 7o_Ch7-2.pPT.contigs > 7o_Ch7-2.pPT.contigs.fasta

