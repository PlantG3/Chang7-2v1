## Biallelic SNPs & DP >=3 filter ##
vcf=sample.raw.0.vcf
ref=reference.fasta
gatk SelectVariants \
        -R $ref \
        -V $vcf \
        -select 'DP>=3' \
        --restrict-alleles-to BIALLELIC \
        -select-type SNP \
        -O sample.bi.1.vcf &>sample.bi.log
        
## chr1-chr10 filter ##        
perl dominant.pl sample.bi.1.vcf > sample.mask.snps.vcf

## minimum allele counts filter ##
invcf=sample.bi.1.vcf
out=sample
mask_snps=sample.mask.snps.vcf
perl vcfbox.pl recall -A 5 -a 0.9 -R 1 -r 0.1 -N 3 -n 0.2 -o ${out}.1.vcf $invcf

## G2A & C2T filter ##
bedtools intersect -header -a ${out}.1.vcf -b $mask_snps -v | awk '$0 ~ /^#/ || $10=="0/1"' > ${out}.2.vcf
cat ${out}.2.vcf | awk '$1=="#CHROM" || $1=="##fileformat=VCFv4.2" || $4=="G" && $5=="A" || $4=="C" && $5=="T"'>${out}.3.EMS.vcf
perl vcfbox.pl recode ${out}.3.EMS.vcf > ${out}.4.EMS.txt
awk '$10=="0/1"' ${out}.2.vcf | cut -f 4,5 | sort | uniq -c > ${out}.5.base.combination.txt