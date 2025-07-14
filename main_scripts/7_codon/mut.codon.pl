#!/usr/bin/perl -w
# Sanzhen Liu
# 3/24/2023

use strict;
use warnings;
use Getopt::Long;

# fasta
my (%seqhash, $seqname, $seq);
open(IN, "<", $ARGV[0]) || die;
while (<IN>) {
	chomp;
	if (/^>(\S+)/) {
		if (defined $seqname) {
			$seqhash{$seqname} = $seq;
		}
		$seqname = $1;
		$seq = '';
	} else {
		$seq .= $_;
	}
}
# last seq
$seqhash{$seqname} = $seq;
close IN;

# table
#chr1	254880169	G	A	Zm00091aa004338	Zm00091aa004338_T003	synonymous	LOW	1146G>A	E382E	1146/1941	1146/1941	382/646	.	104	0.0545454545454545	synonymous
#grep "^seq" -v | awk '$18=="missense" || $18=="synonymous"' | cut -f 1,2,3,4,5,6,12,18 | head 
open(DATA, "<", $ARGV[1]) || die;
while (<DATA>) {
	chomp;
	my @line = split("\t", $_);
	if (($line[0] ne "seq") and (($line[17] eq "missense") or ($line[17] eq "synonymous"))) {
		my $mut_pos = $line[11];
		my $transcript = $line[5];
		$mut_pos =~ s/\/.*//;
		my $codon_pos_start = int(($mut_pos - 1)/ 3) * 3;
		my $codon_pos_end = $codon_pos_start + 3;
		my $wt_codon = "";
		my $mut_codon = "";
		if (exists $seqhash{$transcript}) {
			$wt_codon = substr($seqhash{$transcript}, $codon_pos_start, 3);
			for (my $i=$codon_pos_start; $i<$codon_pos_end; $i++) {
				my $pos_base = substr($seqhash{$transcript}, $i, 1);
				if (($i + 1) == $mut_pos) {
					if ($pos_base eq "G") {
						$mut_codon .= "A";
					} elsif ($pos_base eq "C") {
						$mut_codon .= "T";
					} else {
						print STDERR "$pos_base should be either G or C.\n";
					}
				} else {
					$mut_codon .= $pos_base;
				}
			}
		}
		print "$_\t$wt_codon\t$mut_codon\n";
	} elsif ($line[0] eq "seq") {
		print "$_\tWT\tMUT\n";
	}
}
close DATA;

