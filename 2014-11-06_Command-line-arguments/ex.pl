#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Std;

# option -i for the name of an input file
# option -v for verbose output
#
# e.g.   script -i myinput.txt -v > output.txt

our $opt_i = "";
our $opt_v = 0;
getopts("i:v");

print STDERR "for option i, value is $opt_i\n" if $opt_i;
print STDERR "for option v, value is $opt_v\n" if $opt_v;
