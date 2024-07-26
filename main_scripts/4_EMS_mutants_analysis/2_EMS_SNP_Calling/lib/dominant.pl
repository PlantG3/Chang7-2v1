#!/use/bin/perl -w
# Sanzhen Liu <liu3zhen@ksu.edu>
 
use strict;
use warnings;
use Getopt::Std;

#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	1-1.25x
#ptg000001l	7630	.	G	A	50.42	.	AC=3;AF=0.041;AN=74;BaseQRankSum=1.919;DP=504;ExcessHet=3.1925;FS=0.000;InbreedingCoeff=-0.0465;MLEAC=3;MLEAF=0.041;MQ=60.00;MQRankSum=0.000;QD=1.36;ReadPosRankSum=-1.413;SOR=2.701	GT:AD:DP:GQ:PL	0/0:30,0:30:90:0,90

my $min_consensus = 3;

my $vcf = $ARGV[0];
open(IN, $vcf) || die;
while (<IN>) {
	if (!/\#\#/) {
		chomp;
		my @t = split("\t", $_);
  		if (/^\#CHROM/) { # header
				my $header = join("\t", @t[0..8]);
				print $header."\tDominant\n";
		} else { # genotyping result
			my $genoinfo = join("\t", @t[0..7]);
			my %all_geno_counts;
			
			for (my $i=9; $i<=$#t; $i++) {
				my @geno = split(/\:/, $t[$i]);
				my $geno = $geno[0];
				$all_geno_counts{$geno}++;
			}
				
			my @sort_genos = sort {$all_geno_counts{$b} <=> $all_geno_counts{$a}} keys %all_geno_counts;
			my $dominant_count = $all_geno_counts{$sort_genos[0]};
			if ($dominant_count >= $min_consensus) {
				my $dominant_geno = $sort_genos[0];
				if ($dominant_geno ne "\.\/\." and $dominant_geno ne "0\/0") {
					print $genoinfo."\tGT\t".$dominant_geno."\n";
				}
			}
		}
	} else {
		print "$_";
	}
}
close IN;

