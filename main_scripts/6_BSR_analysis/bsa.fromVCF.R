################################################
### Sanzhen Liu
### 8/9/2012
### This is the code for the BSR-Seq analysis
### The core script was written by Dan Nettleton
### Authors: Sanzhen Liu and Dan Nettleton
### Update:
### v0.2: 10/1/2014
################################################

vcf.readcounts <- function(vcfcounts) {
  #convert count data in a vcf format to an array format
  #GT:AD:DP:GQ:PL
  #0/0:2,0:2:3:0,3,45
  #./.
  all.allelecounts <- NULL
  for (i in 1:length(vcfcounts)) {
    count <- vcfcounts[i]
    allelecounts <- c(0, 0)
    if (grepl(":", count)) {
      ad <- unlist(strsplit(count, ":"))[2]
      allelecounts <- as.numeric(unlist(strsplit(ad, ",")))
    }
    all.allelecounts <- c(all.allelecounts, allelecounts)
  }
  
  ### to avoid the cases with 3 alleles
  if (length(all.allelecounts) != 4) {
    all.allelecounts <- rep(0, 4)
  }
  
  return(all.allelecounts)
}

#======== Start: data subject to change =========#
vcfbsa <- function (in.path=".", vcf.file, out.path=".", out.file,
                    homo.col=10, hetero.col=11,
                    homo.name="MUT", hetero.name="WT",
                    homo.min.depth=6, hetero.min.depth=6,
                    hetero.ref.min=3, hetero.alt.min=3,
                    tolerant.homo.minor.allele.readcount=0,
                    tolerant.homo.minor.allele.freq=0,
                    homo.ind.num=20, total.genetic.length=2338,
                    genetic.interval=20) {

  ### read data from a VCF file:
  cat("Step1: Reading the VCF data ...\n")
  vcf <- read.delim(paste0(in.path, "/", vcf.file), comment.char="#", header=F)
    
  ### convert to a count table
  cat("Step2: Converting count data ...\n")
  ac <- apply(vcf[, c(homo.col, hetero.col)], 1, vcf.readcounts)
  ac <- t(as.matrix(ac))
  cat("Before filtering, the number of markers is: ")
  cat(nrow(ac), "\n")
  
  ### filtering
  cat("Step3: Filtering the variants ...\n")
  filter.criteria <- (ac[, 3] >= hetero.ref.min
                    & ac[, 4] >= hetero.alt.min
                    & (ac[, 3] + ac[, 4]) >= hetero.min.depth
                    & (ac[, 1] + ac[, 2]) >= homo.min.depth)
  
  variants.info <- vcf[filter.criteria, c(1,2,4,5)]
  ac <- ac[filter.criteria, ]
  
  cat("After filtering, the number of markers is: ")
  cat(nrow(ac), "\n")

  ##Find estimated probability that a randomly selected
  ##SNP is in complete linkage disequilibrium with mutant gene.
  dtor <- function(x) {
  # convert genetic distance to recombination rate:
    r = 0.5 * (1 - exp(-2 * x)) # Haldane's mapping function, x is unit in Morgan
    return(r)
  }

  cM <- c(seq(0, genetic.interval, by=0.01)) # with 20cM interval
  rf <- dtor(cM/100)  # recombination rate
  pnr <- (1-rf)^(2*homo.ind.num)  # the prior probability of no recombination 
                                # between the SNP and the causal gene

  ##This is numerical integration of P(no recomb|dist)P(dist)
  ptheta0=sum(2*(0.01/total.genetic.length)*(pnr[-length(pnr)]+pnr[-1])/2)

  ##Find prior distribution of theta
  wt.total <- apply(ac[, 3:4], 1, sum)
  thetahat <- ac[, 3]/wt.total # prior allele frequency
  thetahat <- c(thetahat, 1-thetahat)

  ### function:
  getppp <- function(x) {
    nm=sum(x[1:2]) # Mutant alleles
    nw=sum(x[3:4]) # Wt alleles
    nonma=which.min(x[1:2]) # allele with the smaller number
    xm=min(x[1:2])
    xw=(x[3:4])[nonma]
    ##R="some recombinaton between SNP and causal gene in mutant pool"
    if (xm>tolerant.homo.minor.allele.readcount & (xm/nm)>tolerant.homo.minor.allele.freq) {
      ppmt=0
      ppwt=0
    } else { # no recombination
      ##Find P(x1,x2|R)
      ##Integrate P(x1=0 or n|theta)prior(theta)
      p1=mean((1-thetahat)^nm+thetahat^nm)
      ##Find P(R|x1,x2)
      ppmt=(1/(1+p1*((1-ptheta0)/ptheta0)))
      ##Find P(wm,w) by integrating P(wm,w|theta)prior(theta) 
      p2=mean(dbinom(xw,nw,thetahat))
      ##Find P(wm,w|R)
      p3=mean(dbinom(xw,nw,thetahat[thetahat>=0.5]))
      ##Find P(R|wm,w)
      ppwt=.5*p3/p2
      ##Find the product of the posterior probabilities.
    }
    ppp=ppmt*ppwt
    c(ppmt,ppwt,ppp)
  } # end of the core function code
  
  ### BSR Bayesian analysis
  cat("Step4: Bayesian analysis to determine the probabilities ...\n")
  o <- t(apply(ac, 1, getppp))
  
##Columns are 
##posterior probability from mutant data,
##posterior probability from wild type data,
##product of the posterior probabilities.

  out =data.frame(variants.info, ac,o)
  homo.col.names <- paste(homo.name, c("REFC", "ALTC"), sep=".")
  hetero.col.names <- paste(hetero.name, c("REFC", "ALTC"), sep=".")

  colnames(out)=c("Chr", "Pos", "REF", "ALT",
                  homo.col.names,  hetero.col.names,
                  "ppmt","ppwt","ppp")
  
  write.table(out, paste(out.path, "/", out.file, sep=""), 
              row.names=F, quote=F, sep="\t")
  return(out)
}



# function 2: plotting for a specified chromosome
single.chr.plot <- function(d, chrm, chr.colname="Chr", pos.colname="Pos",
                         bsa.probability.colname="ppp", key.info="", ...){
  plot(d[d[, chr.colname]==chrm, pos.colname]/1000000,
       d[d[, chr.colname]==chrm, bsa.probability.colname],
       xlab=" ",ylab=" ",ylim=c(0, max(d[, bsa.probability.colname])),
       pch=19,cex=0.5,col=rgb(0.2,0.2,0.2,0.6),frame.plot=0)
  #out <- lowess(d[d[, chr.colname]==chrm, pos.colname]/1000000,
  #              d[d[, chr.colname]==chrm, bsa.probability.colname],
  #              f=0.01)
  #lines(out$x,out$y,col="red",lwd=2)
  #lines(d[a==chrm,2]/1000000,o[a==chrm,3],type="s")
  mtext(side=1,line=2.5,"Position (MB)", ...)
  mtext(side=2,line=2.5,"Posterior Probability", ...)
  mtext(side=3,line=2,paste(key.info, ", ",chrm, sep=""), ...)
}

###### plot all chromosomes together ######
maize.all.chr.plot <- function(d, chr.colname="Chr", pos.colname="Pos",
                         bsa.probability.colname="ppp", key.info="",
                         out2file=0, out.path, out.file) {
  if (out2file) { # if need to output figure as a file
    out.path <- gsub("/$", "", out.path)
    pdf(paste(out.path, "/", out.file, sep=""),width=6,height=8)
  }
  # plot
  ppp.max <- min(max(d[, bsa.probability.colname]) + 0.05, 1)
  print(ppp.max)
  #ymax <- max(d$bsa.probability.colname))
  plot(NULL,NULL,xlab="",ylab="",xlim=c(-0.1,310),ylim=c(0, 14),
     frame.plot=0,yaxt="n",cex.axis=0.6)
  mtext(side=1,line=2.5,"Physical Position (MB)",cex=1)
  mtext(side=2,line=3,"Posterior Probability",cex=1)
  mtext(side=3,line=2, key.info, cex=1)
  ### draw y-axes:
  totalchr <- 10
  for (i in c(0,1)) {
    axis(2, at=c(0.5*((1:totalchr)-1)+0:(totalchr-1)+i),
      labels=format(paste(rep(i, totalchr),sep="")),
      pos=(-0.1),cex.axis=0.8,cex.lab=0.8) # left side of axis
	  axis(2, at=c(0.5*((1:totalchr)-1)+0:(totalchr-1)+0.5),
      labels=format(paste("chr",totalchr:1,sep="")),tick=0,
      cex.axis=0.6, cex.lab=0.6)
	  abline(h=c(0.5*((1:totalchr)-1) + (0:(totalchr-1))+i), col="grey")
  }
  ### plot all 10 chromosomes:
  allchr <- paste("chr",1:totalchr,sep="")
  chrm <- 0
  for (chr in allchr) {
    chrm <- chrm + 1
	  points(d[d[, chr.colname]==chr, pos.colname]/1000000,
           d[d[, chr.colname]==chr, bsa.probability.colname]+
             1.5*(totalchr-chrm),
           pch=19,cex=0.2,col=rgb(0.2,0.05,0.2,0.6))
  }
  if (out2file) {
    dev.off()
  }
}

# function 4: plotting for a specified region
region.plot <- function(d, chrm, chr.colname="Chr", pos.colname="Pos",
                        chr.start=0, chr.end=10000000, dot.col="grey",
                        bsa.probability.colname="ppp", key.info="",
                        saveplot=F, plot.width=8, plot.heigh=6,
                        plot.path=".", plot.filename="default.pdf"){
  # save as the file:
  plot.path = gsub("/$", "", plot.path)
  if (saveplot) {
    pdf(paste(plot.path, "/", plot.filename, sep=""), width=plot.width, heigh=plot.heigh)
  }
  plot(d[d[, chr.colname]==chrm, pos.colname],
       d[d[, chr.colname]==chrm, bsa.probability.colname],
       xlim=c(chr.start, chr.end), xlab=" ",ylab=" ",
       ylim=c(0, max(d[, bsa.probability.colname])),
       pch=19, cex=0.5, col=dot.col, frame.plot=0)
  mtext(side=1,line=2.5, paste("Position (bp),", chrm), cex=1.2)
  mtext(side=2,line=2.5,"Posterior Probability",cex=1.2)
  mtext(side=3,line=2,paste(key.info, ", ",chrm, sep=""),cex=1.2)
  if (saveplot) dev.off()
}

# function 5: all chromosome in the same figure:
oneplot2 <- function (input, ymax=NULL, xlab.text="chromosome",
                      main.text="",axisline.width=1.5, chr.set,
                      chr.size, order.by.chrsize=F, label.rm=NULL, cexaxis=0.8,
                      saveplot=FALSE, plot.width=8, plot.heigh=6, 
                      plot.path=".", plot.filename="default.pdf") {
  
  # input should have three columns, "Chr", "Pos", "Prob"
  # size contains length information for every chromosome or contigs
  # size has two columns: chr and size
  plot.path <- gsub("/$", "", plot.path)
  colnames(input) <- c("Chr", "Pos", "Prob")
  input$Chr <- as.character(input$Chr)
  input <- input[input$Chr %in% chr.set, ]
  
  # chromosome length:
  colnames(chr.size) <- c("Chr", "Size")
  chr.size$Chr <- as.character(chr.size$Chr)
  chr.size <- chr.size[chr.size$Chr %in% chr.set, ]
  if (order.by.chrsize) {
    chr.size <- chr.size[order(chr.size$Size, decreasing=T), ]
  }
  # to judge the number is odd or even:
  odd <- function(x) {
    if ((round(x/2,0) - i/2)==0) {
      y <- 0
    } else {
      y <- 1
    }
    return(y)
  }
  
  # plotting
  accum <- 0
  all.col <- NULL
  all.chr <- NULL
  centers <- NULL
  gap <- sum(chr.size$Size)/100
  if (is.null(ymax)) {
    ymax <- max(input$Prob)
  }
  if (saveplot) {
    pdf(paste(plot.path, plot.filename, sep="/"), width=plot.width, heigh=plot.heigh)
  }
  plot(NULL, NULL, ylim=c(0, ymax),
       xlim=c(0, gap*nrow(chr.size)+sum(chr.size$Size)),
       xaxt="n", xlab=xlab.text, ylab="Probability of linkage",
       bty="n", main=main.text)
  
  all.accum <- NULL
  for (i in 1:(nrow(chr.size))) {
    all.accum <- c(all.accum, accum)
    pre.accum <- accum
    chr <- chr.size[i, "Chr"]
    len <- chr.size[i, "Size"]
    if (odd(i)) {
      plot.col = 'blue'
    } else {
      plot.col = "dark green"
    }
    pos <- input[input$Chr==chr, "Pos"]
    prob <- input[input$Chr==chr, "Prob"]
    lines(c(accum, accum+len), c(-(ymax/50), -(ymax/50)), col=plot.col, lwd=axisline.width, lend=1)
    points(accum+pos, prob, pch=19, cex=0.4, col=plot.col)
    accum <- accum + len + gap
    center.point <- (pre.accum + accum - gap)/2
    all.col <- c(all.col, plot.col)
    all.chr <- c(all.chr, chr)
    centers <- c(centers, center.point)
  }
  if (!is.null(label.rm)) {
    for (each.label.rm in label.rm) {
      all.chr <- gsub(each.label.rm, "", all.chr)
    }
  }
  print(all.chr)
  axis(side=1, at=centers, labels=all.chr, tick=F, cex.axis=cexaxis)
  if (saveplot) dev.off()
  
  names(all.accum) <- chr.set
  return(all.accum)
}


