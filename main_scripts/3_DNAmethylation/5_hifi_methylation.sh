## Annotate hifi hinetics in subreads ##
ccs sample.subreads.bam sample.ccs.bam --hifi-kinetics

## Predict 5mC probabilityies and add SAM tags ##
primrose sample.ccs.bam sample.5mc.bam

## Align HiFi reads to reference genome ##
pbmm2 index reference.fasta reference.mmi
pbmm2 align --sort -j 6 reference.mmi sample.5mc.bam sample.aln.bam

## Calculate 5mC pileup scores ##
python aligned_bam_to_cpg_scores.py -b sample.aln.bam -f reference.fasta -o sample -p model -d pb-CpG-tools-main/pileup_calling_model -m reference -t 24