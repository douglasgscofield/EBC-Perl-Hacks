#!/usr/bin/env perl

#!/usr/bin/env perl

use strict;
use warnings;

open(F1, "<$ARGV[0]") or die "$!";
open(F2, "<$ARGV[1]") or die "$!";

sub make_key($$) {
    my $n1 = shift;
    my $n2 = shift;
    return "${n1}_${n2}";
}

my %F2;
while (<F2>) {
    chomp;
    my @l = split;
    $F2{ make_key($l[1], $l[2]) } = $l[4];
}
close F2;

while (<F1>) {
    chomp;
    my @l = split;
    my $k = make_key($l[0], $l[1]);
    if (! $F2{$k})) {
        print STDERR "$k is not defined in F2, skipping\n";
        next;
    }
    print STDOUT join("\t", @l, $F2{ j($l[0], $l[1]) }), "\n";
}
