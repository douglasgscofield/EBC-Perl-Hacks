#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Std;

# option -i for the name of an input file
# option -v for verbose output
#
# e.g.   script -i myinput.txt -v > output.txt

print STDERR join("  :  ", @ARGV), "\n";

my %options;
getopts("i:v", \%options) or die;

print STDERR "option $_ value is $options{$_}\n" foreach sort keys %options;

print STDERR join("  :  ", @ARGV), "\n";

while (<>) {
    # work on things
}
