#!/usr/bin/env perl
#
# Demonstrates using Getopt::Std's getopts() using using default opt_ variable names

use strict;
use warnings;

use Getopt::Std;

# option -p for a string to prefix each line of the files with
# option -v for verbose output
#
# e.g.   script -p 'prefix: ' -v file1.txt file2.txt

our $opt_i = "";
our $opt_v = 0;

print STDERR "Command-line arguments BEFORE getopts:: ", join(" , ", @ARGV), "\n";

getopts("i:v") or die "something wrong with your arguments";

print STDERR "Command-line arguments AFTER getopts :: ", join(" , ", @ARGV), "\n";

print STDERR "for option p, value is $opt_p\n" if $opt_p;
print STDERR "for option v, value is $opt_v\n" if $opt_v;

while (<>) {
    if ($opt_v) {
        print $opt_p if $opt_p;
        print;
    }
}
