#!/usr/bin/env perl

use strict;
use warnings;

my $a = "acgtacgt";
my @seq;

print "method 1\n";
print substr($a,$_,1), "\n" foreach 0..(length($a)-1);
print "method 2\n";
@seq = split //, $a;
print "$_\n" foreach @seq;
print "method 3\n";
@seq = map { $_ - 33 } unpack "(c)*", $a;
print "$_\n" foreach @seq;
