blp <- read.delim("../09b_blastp/09b1o_prot.blastp", header = F, stringsAsFactors = F)
blp$V1 <- gsub("_P", "_T", blp$V1)
major <- read.delim("../09d_majorTranscripts/Chang7-2v1a0.1.major.transcripts.txt", stringsAsFactors = F)
blp <- blp[blp$V1 %in% major$Transcript, ]
blp$Gene <- gsub("_T.*", "", blp$V1)
blp <- blp[order(blp$Gene, blp$V10), ]

blp$Description <- gsub(" OS=.*", "", blp$V9)
blp$Symbol <- ""
blp$Symbol[grep("GN=", blp$V9)] <- blp$V9[grep("GN=", blp$V9)]
blp$Symbol <- gsub(".*GN=", "", blp$Symbol)
blp$Symbol <- gsub(" PE=.*", "", blp$Symbol)
blp$Evalue <- blp$V10
#hist(-log10(blp$V10), nclass=100)

colnames(blp)
blp2 <- blp[, c("Gene", "Symbol", "Description", "Evalue")]
colnames(blp2) <- c("Gene", "Symbol", "Description", "SwissProt_evalue")



# gene info
genes <- read.delim("Chang7-2v1a0.1.genes", header = F)
colnames(genes) <- c("Chr", "Start", "End", "Strand", "Gene")
genes.db <- merge(genes, major[, c("Gene", "Transcript")], by="Gene", all=T)
genes.db <- merge(genes.db, blp2, by="Gene", all=T)
head(genes.db)

# output:
write.table(blp2, "Chang7-2v1a0.1.description", row.names = F, quote = F, sep = "\t")
write.table(genes.db, "Chang7-2v1a0.1.genes.info", row.names = F, quote = F, sep = "\t")

