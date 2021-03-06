#!/usr/bin/env perl

# Demonstrates using Getopt::Std's getopts() using a hash to hold option values.

use strict;
use warnings;

use Getopt::Std;
my %options;

# option -p for a string to prefix each line of the files with
# option -v for verbose output
#
# e.g.   script -p 'prefix: ' -v file1.txt file2.txt

print STDERR "Command-line arguments BEFORE getopts:: ", join(" , ", @ARGV), "\n";

getopts("p:v", \%options) or die "something wrong with your arguments";

print STDERR "Command-line arguments AFTER getopts :: ", join(" , ", @ARGV), "\n";

print STDERR "option $_ value is $options{$_}\n" foreach sort keys %options;

while (<>) {
    if ($options{v}) {
        print $options{p} if $options{p};
        print;
    }
}
