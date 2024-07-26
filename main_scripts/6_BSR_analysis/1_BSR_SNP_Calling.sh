## STAR alignment ##
STAR --runThreadN 4 --genomeDir reference_folder --readFilesIn MUT_R1.fq.gz MUT_R2.fq.gz --readFilesCommand zcat --alignIntronMax 100000 --alignMatesGapMax 100000 --outFileNamePrefix MUT --outSAMattrIHstart 0 --outSAMmultNmax 1 --outSAMstrandField intronMotif --outFilterIntronMotifs RemoveNoncanonicalUnannotated --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outFilterMismatchNmax 5 --outFilterMismatchNoverLmax 0.05 --outFilterMatchNmin 50 --outSJfilterReads Unique --outFilterMultimapNmax 1 --outSAMmapqUnique 60 --outFilterMultimapScoreRange 2
STAR --runThreadN 4 --genomeDir reference_folder --readFilesIn WT_R1.fq.gz WT_R2.fq.gz --readFilesCommand zcat --alignIntronMax 100000 --alignMatesGapMax 100000 --outFileNamePrefix WT --outSAMattrIHstart 0 --outSAMmultNmax 1 --outSAMstrandField intronMotif --outFilterIntronMotifs RemoveNoncanonicalUnannotated --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outFilterMismatchNmax 5 --outFilterMismatchNoverLmax 0.05 --outFilterMatchNmin 50 --outSJfilterReads Unique --outFilterMultimapNmax 1 --outSAMmapqUnique 60 --outFilterMultimapScoreRange 2

## GATK SNP Calling ## 
gatk AddOrReplaceReadGroups --java-options '-Xmx24g' -I MUTAligned.sortedByCoord.out.bam -O MUT_GR.bam -LB A -PL illumina -PU A -SM MUT -ID MUT
gatk AddOrReplaceReadGroups --java-options '-Xmx24g' -I WTAligned.sortedByCoord.out.bam -O WT_GR.bam -LB A -PL illumina -PU A -SM WT -ID WT
samtools sort -o MUT_sort.bam MUT_GR.bam
samtools sort -o WT_sort.bam WT_GR.bam
samtools index MUT_sort.bam
samtools index WT_sort.bam
gatk HaplotypeCaller --java-options '-Xmx48g' -R reference.fasta -I MUT_sort.bam -I WT_sort.bam -O BSR.vcf.gz --native-pair-hmm-threads 4

## SNP filtering ##
gatk SelectVariants --java-options '-Xmx48g' \
-R referemce.fasta \
-V BSR.vcf.gz \
-select 'QD > 2.0' -select 'FS < 40.0' -select 'MQRankSum > -12.5' -select 'ReadPosRankSum > -8.0' -select 'DP > 20.0' \
--restrict-alleles-to BIALLELIC \
--select-type-to-include SNP \
--sample-name MUT --sample-name WT \
--exclude-filtered \
--exclude-non-variants \
-O BSR_filter.vcf

