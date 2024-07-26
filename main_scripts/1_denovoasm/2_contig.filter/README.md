### potential mt (pmt):
#pmt <- srcov[srcov$ie_RPKM>srcov$leaf_RPKM*1.5 & srcov$ie_RPKM>0.0025, 1] # ptg001207l
#ppt <- srcov[srcov$leaf_RPKM > srcov$ie_RPKM*5 & srcov$leaf_RPKM>=0.0025, 1] # ptg001207l

Both leaves and immature embryos were used to generate whole genome sequencing data. The proportion of mitochondrial DNAs are expected to be more in immature embryos and the proportion of chloroplast DNAs are expected to be more in leaves.

Therefore, we categorized a contig to a potential mitochondrial sequence (pmt) If its RPKM of immature embryos is 1.5 times of that of leaves. In constrast, if the RPKM of leaves is 5 times of that of immature embryos, the contig was categorized to a potential chloroplast sequence (ppt).


