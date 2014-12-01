#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper::Perltidy;

$Data::Dumper::Useqq = 1;

while (<>) {
    chomp;
    next if not /^# ID +([^ ]+)/;
    my $id = $1;
    my $h1 = <>;
    chomp $h1;
    $h1 =~ tr/\0/N/;
    #print STDERR Dumper($h1);
    $h1 =~ s/ //g;
    print ">$id\n";
    print "$h1\n";
}
