#!/usr/bin/perl -w
#
# ============================================================
# File: cds.codon.stat.pl
# Author: Sanzhen Liu
#
# ============================================================

use strict;
use warnings;
use Getopt::Long;
use Bio::Tools::CodonTable;

my ($cds, $canonical, $quiet, $help);

sub prompt {
	print <<EOF;
  Usage: perl $0 <Input CDS FASTA> [--help]
  --cds|f <file>: FASTA file of full-length CDS sequences of each gene (required)
  --canonical|c : only use sequences with canonical start and stop codons (off)
                  (canonical: ATG as the start codon and TAA/TAG/TGA as the stop codons)
  --quiet|q     : no warning messages if specified (off)
  --help|h      : help information
EOF
exit;
}

# read the parameters:
&GetOptions("cds|f=s"     => \$cds,
            "canonical|c" => \$canonical,
			"quiet|q"     => \$quiet,
			"help"        => \$help) || &prompt;

if ($help) {
	&prompt;
}

if (!defined $cds) {
	print STDERR "Error: --cds is required\n";
	exit;
}

# defaults to ID 1 "Standard"
my $myCodonTable   = Bio::Tools::CodonTable->new();

# counting
my (%codon_stat, $seq_name);
my ($first_codon, $last_codon);
my (%first_codon_stat, %last_codon_stat);
my $seq = "";
my $seq_count = 0;
open(IN, "<", $cds) || die;
# Read all sequence (name and size) into hash;
while (<IN>) {
	$_ =~ s/\R//g;
	chomp;
	if (/^>(\S+)/) {
		$seq_count++;
		if (defined $seq_name) {
			# first codon
			$first_codon = substr($seq, 0, 3, ""); # extract 3 bases and remove them
			my $is_first_canonical = ($first_codon eq "ATG");

			if (!$is_first_canonical) {
				&warning("the 1st codon of $seq_name is not ATG", $quiet);
			}

			if (!$canonical or ($canonical and $is_first_canonical)) {
				$first_codon_stat{$first_codon}++;
			}
			
			# last codon
			$last_codon = substr($seq, -3, 3, "");
			
			my $is_last_canonical = (($last_codon eq "TGA") or ($last_codon eq "TAG") or ($last_codon eq "TAA"));
			if (!$is_last_canonical) {
				&warning("the last codon of $seq_name is not TGA/TAG/TAA", $quiet);
			}
			
			if (!$canonical or ($canonical and $is_last_canonical)) {
				$last_codon_stat{$last_codon}++;
			}
			
			# internal codons
			my $internal_length = length($seq);
			if (!$canonical or ($canonical and $is_first_canonical and $is_last_canonical)) {
				if (($internal_length % 3)==0) { # length is divisible of 3
					while (my $each_codon = substr($seq, 0, 3, "")) {
						$codon_stat{$each_codon}++;
					}
				} else {
					&warning("length of $seq_name is not divisible by 3", $quiet);
				}
			}
		}
		$seq_name = $1;
		$seq = "";
	} else {
		$_ =~ s/\s//g;
		$seq .= $_;
	}
}

# last element:
# first codon
$first_codon = substr($seq, 0, 3, "");
my $is_first_canonical = ($first_codon eq "ATG");

if (!$is_first_canonical) {
	&warning("the 1st codon of $seq_name is not ATG, $quiet")
}

if (!$canonical or ($canonical and $is_first_canonical)) {
	$first_codon_stat{$first_codon}++;
}
			
# last codon
$last_codon = substr($seq, -3, 3, "");
			
my $is_last_canonical = (($last_codon eq "TGA") or ($last_codon eq "TAG") or ($last_codon eq "TAA"));
if (!$is_last_canonical) {
	&warning("the last codon of $seq_name is not TGA/TAG/TAA", $quiet);
}
			
if (!$canonical or ($canonical and $is_last_canonical)) {
	$last_codon_stat{$last_codon}++;
}
			
# internal codons
my $internal_length = length($seq);
if (!$canonical or ($canonical and $is_first_canonical and $is_last_canonical)) {
	if (($internal_length % 3)==0) {
		while (my $each_codon = substr($seq, 0, 3, "")) {
			$codon_stat{$each_codon}++;
		}
	} else {
		&warning("length of $seq_name is not divisible by 3", $quiet);
	}
}

close IN;

# report:
print STDERR "Number of seqs: $seq_count\n";
&hash2table(\%first_codon_stat, "first_codon");
&hash2table(\%last_codon_stat, "last_codon");
&hash2table(\%codon_stat, "internal_codon");

### modules
sub hash2table {
# output statistics
	my ($in_stat, $in_note) = @_;
	my %in_stat = %{$in_stat};
	foreach (sort {$a cmp $b} keys %in_stat) {
		my $aa = $myCodonTable->translate($_);
		print "$_\t$in_stat{$_}\t$aa\t$in_note\n";
	}
}

sub warning {
	my ($warning_content, $quiet_signal) = @_;
	if (!$quiet_signal) {
		print STDERR "Warning: $warning_content\n"
	}
}
