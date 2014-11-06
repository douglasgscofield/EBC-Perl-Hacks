#!/usr/bin/env perl

# Parse a VCF file and calculating mean depth for variant entries belonging
# to particular sample names.  The first argument is the VCF file name, the second
# and subsequent arguments are sample names to operate on.  If just one sample
# name is given, it may be a regular expression that will be used to find sample
# names dynamically.

use strict;
use warnings;
use List::Util qw(sum);
my $verbose = 0;

my $file = shift @ARGV;
my @samples;
my $regexp;

if ($#ARGV) {
    # if there is more than one command-line argument, they are multiple literal sample names
    @samples = @ARGV;
} else {
    # there is just one argument, so it is a regexp (which may be one literal sample name)
    $regexp = shift @ARGV;
}

## open the file and read lines until we find the header line beginning with #CHROM
open FILE, "<$file" or die "$!";
while (<FILE>) {
    last if /^#CHROM/;
}

## Process the #CHROM line to find which columns match the requested sample name(s)
#
# break #CHROM line into fields (@l) and make hash %index where key=field and value=column number
chomp;
my @l = split;
my %index;
$index{ $l[$_] } = $_ foreach (0..$#l);

# If @samples is empty (we had just one argument) then look for sample columns in
# the fields of the #CHROM line (@l) which match the single argument given (again,
# which may be a regexp) and store matching names in @samples
@samples = grep { /$regexp/ } @l[9..$#l] if not scalar @samples;
print STDERR "samples: ",join(",", @samples),"\n";

# Double-check that the set of samples can be found in this file, and get their
# column numbers
foreach (@samples) {
    die "sample $_ not found" if not defined($index{$_}) or $index{$_} < 9;
}
my @cols = @index{@samples};
print STDERR "samples are found at columns ", join(",", @cols), "\n";

# read the file, exploding each VCF line and exploding each genotype for requested samples
while (<FILE>) {
    chomp;
    my @line = split; my $i = 0;
    print STDERR "genotype format is $line[8]\n" if $verbose;
    my %igt = map { $_ => $i++ } split(":", $line[8]);
    my $n_gtfields = scalar keys %igt;
    next if not defined($igt{DP}) or scalar keys %igt <= 2;
    print STDERR "for line $., hash field has key $_ at position $igt{$_}\n" foreach keys %igt if $verbose;
    # genotype lines
    my @dp;
    foreach my $c (@cols) {
        my @sgt = split ":", $line[$c];
        next if scalar @sgt < $n_gtfields;
        # Our chosen statistic is based on the DP field, but we could summarise any 
        # of the genotype fields here
        push @dp, $sgt[$igt{DP}];
    }
    print STDERR "genotype field is $_\n" foreach (@line[@cols]) if $verbose;
    my $n = scalar @dp;
    print STDERR "mean coverage is ", $n ? sum(@dp)/$n : "undefined", "\n";
}

