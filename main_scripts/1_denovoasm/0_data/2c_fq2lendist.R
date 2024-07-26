source("~/scripts/fastq/fqlen2hist.R")
pdf("Chang72pb.readlen.pdf", width = 6, height = 5)
fqlen2hist(path=".", feature = "fastq$", title="Chang7- 2PacBio")
dev.off()

