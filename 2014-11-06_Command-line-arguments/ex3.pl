#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;

# option -i for the name of an input file
# option -v for verbose output
#
# e.g.   script -i myinput.txt -v > output.txt

print STDERR join("  :  ", @ARGV), "\n";

my $opt_i = "";
my $opt_v = 1;
my $opt_help = 0;
GetOptions("i=s" => \$opt_i,
           "v" => \$opt_v)     or usage();

sub usage() {
    print STDERR "

How to use $0
-i file  : specify input file
-v       : be verbose

";
    exit 1;
}


print STDERR "for option i, value is $opt_i\n" if $opt_i;
print STDERR "for option v, value is $opt_v\n" if $opt_v;

while (<>) {
    # work on things
}
