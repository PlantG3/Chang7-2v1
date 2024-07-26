setwd("/bulk/liu3zhen/research/projects/Chang7-2/main_sl/3_contig.filter")

# contigs
lens <- read.delim("1o_ch7-2.ctg.length", header=F)
colnames(lens) <- c("contig", "len")

# Illumina alignments
alnsum <- read.delim("../2_Illumia/2e_aln/2e2o_alnsummary.txt")
libsize <- alnsum[, "ConfidentMapped"]
names(libsize) <- gsub("\\.sam", "", alnsum[, "File"])
names(libsize) <- gsub("ch7\\-2", "", names(libsize))
libsize

# B73v4 anchored
b73v4 <- read.delim("2o_ragtag-B73v4/ragtag.scaffold.agp", header=F, comment.char="#")
b73v4 <- b73v4[b73v4[,5]=="W", ]
b73v4anchored <- b73v4[!grepl("^ptg", b73v4[,1]), c(6, 1, 9)]
colnames(b73v4anchored) <- c("contig", "B73v4", "B73v4ori")
b73v4anchored$B73v4 <- gsub("_RagTag", "", b73v4anchored$B73v4)

#b73v4mt <- b73v4[grep("^Mt", b73v4[,1]), 6]
#b73v4pt <- b73v4[grep("^Pt", b73v4[,1]), 6]

# B73v5 anchored
b73v5 <- read.delim("4o_ragtag_output/ragtag.scaffold.agp", header=F, comment.char="#")
b73v5 <- b73v5[b73v5[,5]=="W", ]
b73v5anchored <- b73v5[!grepl("^ptg", b73v5[,1]), c(6, 1, 9)]
colnames(b73v5anchored) <- c("contig", "B73v5", "B73v5ori")
b73v5anchored$B73v5 <- gsub("_RagTag", "", b73v5anchored$B73v5)

# A188 anchored
a188 <- read.delim("3o_ragtag-A188Ref1//ragtag.scaffold.agp", header=F, comment.char="#")
a188 <- a188[a188[,5]=="W", ]
a188anchored <- a188[!grepl("^ptg", a188[,1]), c(6, 1, 9)]
colnames(a188anchored ) <- c("contig", "A188Ref1", "A188Ref1ori")
a188anchored$A188Ref1 <- gsub("_RagTag", "", a188anchored$A188Ref1)

#a188mt <- a188[grep("^mt", a188[,1]), 6]
#a188mt
#a188pt <- a188[grep("^Pt", a188[,1]), 6]
#a188pt

allanchored <- unique(c(b73v4anchored, b73v5anchored, a188anchored))
length(allanchored)

# B73v4 coverage
b73cov <- read.delim("2o_B73v4.mapped.contigs.coverages.bed", header=F)
b73cov <- b73cov[, c(1,3,7)]
colnames(b73cov) <- c("contig", "len", "B73v4coverage")
# all contigs have a good coverage

# Illumina coverage:
srcov <- read.delim("1o_ch7-2leaf_ie.cov", header = F) # read counts
srcov <- srcov[, -2]
colnames(srcov) <- c("contig", "len", "leaf", "ie")

#srcov[srcov$contig %in% nocov_ctgs[nocov_ctgs %in% allanchored], ]
#sum(srcov$len[srcov$contig %in% allanchored] < 15000)
#nocov_ctgs <- srcov[srcov$leaf + srcov$ie < 1, 1]
#sum(nocov_ctgs %in% allanchored)

adjust_counts <- 0
srcov$leaf_RPKM <- (srcov$leaf + adjust_counts*libsize["leaf"]/libsize["ie"]) / libsize["leaf"] * 1000000 / srcov$len * 1000
srcov$leaf_RPKM <- round(srcov$leaf_RPKM, 5)
srcov$ie_RPKM <- (srcov$ie + adjust_counts) / libsize["ie"] * 1000000 / srcov$len * 1000
srcov$ie_RPKM <- round(srcov$ie_RPKM, 5)

### plot
plot(srcov$leaf_RPKM, srcov$ie_RPKM)
points(srcov$leaf_RPKM[srcov$contig %in% b73v4mt], srcov$ie_RPKM[srcov$contig %in% b73v4mt], pch=19, col="pink", cex=1.2)
points(srcov$leaf_RPKM[srcov$contig %in% a188mt], srcov$ie_RPKM[srcov$contig %in% a188mt], pch=19, col="brown", cex=0.5)

plot(srcov$leaf_RPKM, srcov$ie_RPKM, xlim=c(0,23), ylim=c(0,23))
plot(srcov$leaf_RPKM, srcov$ie_RPKM, xlim=c(0,10), ylim=c(0,10), cex=0.1)
points(srcov$leaf_RPKM[srcov$contig %in% b73v4mt], srcov$ie_RPKM[srcov$contig %in% b73v4mt], pch=19, col="pink", cex=1.2)
points(srcov$leaf_RPKM[srcov$contig %in% a188mt], srcov$ie_RPKM[srcov$contig %in% a188mt], pch=19, col="brown", cex=0.5)

plot(srcov$leaf_RPKM, srcov$ie_RPKM, xlim=c(0,2), ylim=c(0,2))
points(srcov$leaf_RPKM[srcov$contig %in% b73v4mt], srcov$ie_RPKM[srcov$contig %in% b73v4mt], pch=19, col="pink", cex=1.2)
points(srcov$leaf_RPKM[srcov$contig %in% a188mt], srcov$ie_RPKM[srcov$contig %in% a188mt], pch=19, col="brown", cex=0.5)


plot(srcov$leaf_RPKM, srcov$ie_RPKM, xlim=c(0,0.1), ylim=c(0,0.1))
points(srcov$leaf_RPKM[srcov$contig %in% b73v4mt], srcov$ie_RPKM[srcov$contig %in% b73v4mt], pch=19, col="pink", cex=1.2)
points(srcov$leaf_RPKM[srcov$contig %in% a188mt], srcov$ie_RPKM[srcov$contig %in% a188mt], pch=19, col="brown", cex=0.5)

### potential mt (pmt):
pmt <- srcov[srcov$ie_RPKM>srcov$leaf_RPKM*1.5 & srcov$ie_RPKM>0.0025, 1] # ptg001207l

### potential pt (ppt):
ppt <- srcov[srcov$leaf_RPKM > srcov$ie_RPKM*5 & srcov$leaf_RPKM>=0.0025, 1] # ptg001207l

#srcov[srcov$leaf_RPKM>100, ] # ptg001207l
#srcov[srcov$contig == "ptg000197l", ]
#srcov[srcov$contig == "ptg001207l", ]

# merge
out <- merge(srcov, b73cov[,-2], by = "contig", all = T)
out <- merge(out, a188anchored, by = "contig", all = T)
out <- merge(out, b73v4anchored, by = "contig", all = T)
out <- merge(out, b73v5anchored, by = "contig", all = T)
out$depInference <- "-"
out$depInference[out$contig %in% pmt] <- "pMT"
out$depInference[out$contig %in% ppt] <- "pPT"
head(out)
# output
write.table(out, "6o_Ch2.contigs.db", row.names = F, quote = F, sep = "\t")

