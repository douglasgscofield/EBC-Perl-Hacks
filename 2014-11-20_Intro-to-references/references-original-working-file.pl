#!/usr/bin/env perl

# This is the file as created in class.  I removed earlier examples by
# successively closing them off with __END__, which can be a neat trick to use
# when quickly prototyping a Perl script.

use strict;
use warnings;
use Data::Dumper;

my @alph = qw/a b c d e f g h i j k l m n o p q r s t u v w x y z/;

my %j;
$j{a} = [ @alph[0..3] ];
print Dumper(\%j);

my $a = shift @{$j{a}};
my $b = shift $j{a};
print $a,"\n";
print $b,"\n";
print Dumper(\%j);

__END__
my %j;
$j{a} = [ @alph[0..3] ];
$j{h} = [ @alph[7..12] ];
$j{q} = [ @alph[17..19] ];
print Dumper(\%j);

__END__

sub p($@) {
    my $i = shift;
    my @a = @_;
    print STDERR $a[$i],"\n";
}
p(3, @alph);

sub r($$) {
    my $i = shift;
    my $a = shift;
    print STDERR @{$a}[$i],"\n";
    print STDERR $a->[$i],"\n";
}
r(3, \@alph);

__END__
my %h;

$h{a}{1} = "yes";
$h{a}{2} = "maybe";
$h{a}{3} = "no";

print Dumper(\%h);
