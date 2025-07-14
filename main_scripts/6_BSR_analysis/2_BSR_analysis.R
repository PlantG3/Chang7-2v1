source("bsa.fromVCF.R")
all <- c("BSR_filter.vcf")
allchr <- paste0("chr",1:10)
chrsize <- read.delim("B73Ref5.length.txt")
for (i in all) {
  bsr <- vcfbsa(in.path=".", vcf.file=paste0(i,".vcf"),
                homo.name=paste0(i,"MUT"), hetero.name=paste0(i,"WT"),
                out.path=".", out.file=paste0(i, ".bsr.txt"))
  oneplot2(bsr[, c("Chr", "Pos", "ppp")], ymax=NULL, xlab.text="chromosome",
           main.text=i, axisline.width=1.5, chr.set=allchr,
           chr.size=chrsize[,1:2], order.by.chrsize=F, label.rm="chr", cexaxis=1.2,
           saveplot=T, plot.width=8, plot.heigh=6, 
           plot.path="./", plot.filename=paste0(i, ".bsr.oneplot.pdf")) 
}
