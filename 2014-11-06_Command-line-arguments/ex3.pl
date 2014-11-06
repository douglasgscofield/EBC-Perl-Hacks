#!/usr/bin/env perl

# Demonstrates using Getopt::Long's GetOptions() with
# simple options, and using multiline strings to produce
# output (see usage).

use strict;
use warnings;

use Getopt::Long;

my $opt_p = "";
my $opt_v = 0;
my $opt_help = 0;

# option -p for a string to prefix each line of the files with
# option -v for verbose output
#
# e.g.   script -p 'prefix: ' -v file1.txt file2.txt

sub usage() {
    print STDERR "

How to use $0
-p file  : specify prefix for output lines [default is \"$opt_p\"]
-v       : be verbose [default is $opt_v]

";
    exit 1;
}

print STDERR "Command-line arguments BEFORE GetOptions:: ", join(" , ", @ARGV), "\n";

GetOptions("p=s" => \$opt_p,
           "v"   => \$opt_v)     or usage();

print STDERR "Command-line arguments AFTER GetOptions :: ", join(" , ", @ARGV), "\n";

print STDERR "for option p, value is $opt_p\n" if $opt_p;
print STDERR "for option v, value is $opt_v\n" if $opt_v;

# work on files remaining on the command line (the rest of @ARGV)

while (<>) {
    if ($opt_v) {
        print $opt_p if $opt_p;
        print;
    }
}
