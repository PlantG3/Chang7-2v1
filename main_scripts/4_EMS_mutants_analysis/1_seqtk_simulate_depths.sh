## 25x*0.6=15x ##
seqtk sample -s123 sample.R1.fq.gz 0.6 > sample.15x.R1.pair.fq
seqtk sample -s123 sample.R2.fq.gz 0.6 > sample.15x.R2.pair.fq

## 25x*0.4=10x ##
seqtk sample -s123 sample.R1.fq.gz 0.4 > sample.10x.R1.pair.fq
seqtk sample -s123 sample.R2.fq.gz 0.4 > sample.10x.R2.pair.fq

## 25x*0.3=7.5x ##
seqtk sample -s123 sample.R1.fq.gz 0.3 > sample.7.5x.R1.pair.fq
seqtk sample -s123 sample.R2.fq.gz 0.3 > sample.7.5x.R2.pair.fq

## 25x*0.2=5x ##
seqtk sample -s123 sample.R1.fq.gz 0.2 > sample.5x.R1.pair.fq
seqtk sample -s123 sample.R2.fq.gz 0.2 > sample.5x.R2.pair.fq
