#!/usr/bin/perl -w
# Sanzhen Liu, liu3zhen@ksu.edu
# Date: 2/11/2025

use strict;
use warnings;
use Getopt::Long;

my ($fas, $snp, $help);
my $result = &GetOptions("fas|f=s"     => \$fas,
						 "snp|s=s"     => \$snp,
						 "help|h"      => \$help
);

# print help information if errors occur:
if ($help or !defined $fas or !defined $snp) {
	&errINF;
	exit;
}

### fasta sequences:
my ($seqname, $seqlen, $seq, %seqhash, %lenhash);
open(IN, "<", $fas) || die;
while (<IN>) {
	chomp;
	if (/^>(\S+)/) {
		if (defined $seqname) {
			$seqhash{$seqname} = $seq;
			$lenhash{$seqname} = $seqlen;
		}
		$seqname = $1;
		$seq = '';
		$seqlen = 0;
	} else {
		$seq .= $_;
		$seqlen += length($_);
	}
}
# last seq
$seqhash{$seqname} = $seq;
$lenhash{$seqname} = $seqlen;
close IN;


### SNP 4-col file
#in: chr1 300 G   A
#out: chr	start	end	pos	ref	alt	sequences
#     chr1	315858	316370	316114	C	T	CTCTCCCGATGT...512bp
my $len_to_extract = 512; # need to be an even number
print "chr\tstart\tend\tpos\tref\talt\tsequences\n";
open(SNP, "<", $snp) || die;
while (<SNP>) {
	chomp;
	my @line = split(/\t/, $_);
	my ($chr, $pos, $ref, $alt) = @line[0..3];
	if (exists $seqhash{$chr} and $pos =~ /^\d+$/) {
		my $start = $pos - $len_to_extract / 2; # 0-based
		my $end = $pos + $len_to_extract / 2;   # 1-based
		if ($start >= 0 and $end <= $lenhash{$chr}) { 
			my $snpcontext = substr($seqhash{$chr}, $start, $len_to_extract);
			print "$chr\t$start\t$end\t$pos\t$ref\t$alt\t$snpcontext\n";
		}
	}
}
close SNP;

###########################################
sub errINF {
	print <<EOF;
Usage: perl $0 --fas <fasta> --snp <file>]
[Options]
    --fas|f <file> : fasta file (required)
    --snp|s <file> : SNP file (required)
                     e.g., chr1	300	G	A
    --help         : help information
EOF
	exit;
}

