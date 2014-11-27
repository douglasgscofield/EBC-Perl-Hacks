#!/usr/bin/env perl

use strict;
use warnings;
#use Data::Dumper;
use Data::Dumper::Perltidy;

my @alph = qw/a b c d e f g h i j k l m n o p q r s t u v w x y z/;

# Scalar and list contexts

# Put the array in scalar context to get its length, and escape the @
# in its name when it appears in a double-quoted string to keep Perl
# from performing value substitution
print "The length of \@alph is ".scalar(@alph)."\n";
# The string can also be single-quoted to avoid value substitution.
print 'The length of @alph is '.scalar(@alph)."\n";

# Within a string, the context used is generally the "natural" one for
# the data; a list is expanded into the values of its elements separated
# by single spaces.
my @s = @alph[0..3];
print "The contents of \@s are '@s'\n";

print "@alph\n";

# Checking the length of a list: is it empty?

print "\@alph is empty\n" if scalar(@alph) == 0;  # we already know this
# $#list is the position of the last element of the list
print "\@alph's last element position is ".$#alph.", the value of which is ".$alph[$#alph]."\n";
# We can calculate the length of the list using $#list + 1
print "The length of \@alph is ".($#alph + 1)."\n";
# If the list is empty, $#list == -1
print "\@alph is empty\n" if $#alph == -1;
my @b;  # this list is empty
print "b is empty\n" if $#b == -1;

# Comparisons force scalar context on a list.  So, you can also check for an
# empty list by comparing directly against the list.

print "\@alph is longer than 17\n" if @alph > 17;
print "b is empty\n" if ! @b;
print "b is empty\n" if @b == 0;

# Back to references.  We'll write a subroutine to compare two lists.

my $verbose = 1;
sub list_compare_1($$) {
    my ($a, $b) = @_;  # entire argument list is @_
    print Dumper($a) if $verbose;  # note parent scope for $verbose
    print Dumper($b) if $verbose;
    # The first comparison we should make is the lengths of the lists;
    # if their lengths are different their contents cannot be 
    # identical, and the subroutine might return its result quickly if 
    # we check for this case first.
    if ($a != $b) {
        print "lists are different lengths\n" if $verbose;
        return 0;
    }
    # Let's stop here and see how we are doing when just checking length.
    print "lists are different lengths\n" if $verbose;
    return 1;
}
my @x = 1..3;
my @y = qw/a b c/;
# The length of both lists is 3, so list_compare_1() should return 1, right?
print "1a: list_compare_1() returns ".list_compare_1(\@x, \@y)."\n";
# What if we pass two anonymous arrays, first of length 4, second of length 3:
print "1b: list_compare_1() returns ".list_compare_1(['p', 'q', 'r', 's'], [9, 8, 7])."\n";

# So somehow our length comparison isn't working like we thought it would...
# maybe it has something to do with using references.  Let's try various ways
# of printing with references inside a subroutine.

sub check_context($$) {
    my ($a, $b) = @_;
    print "reference \$a in scalar context is '".scalar($a)."'\n";
    print "reference \$b in scalar context is '".scalar($b)."'\n";
    print "reference \$a in 'string' context is '$a'\n";
    print "reference \$b in 'string' context is '$b'\n";
    print "reference \$a cast to an array '\@{\$a}' in 'string' context is '@$a'\n";
    print "reference \$b cast to an array '\@{\$b}' in 'string' context is '@$b'\n";
    print "reference \$a cast to an array '\@\$a' in 'string' context is '@{$a}'\n";
    print "reference \$b cast to an array '\@\$b' in 'string' context is '@{$b}'\n";
    print "reference \$a cast to an array '\@\$a' in scalar context is '".scalar(@{$a})."'\n";
    print "reference \$b cast to an array '\@\$b' in scalar context is '".scalar(@{$b})."'\n";
}
# Named arrays passed by reference
check_context(\@x, \@y);
# Anonymous arrays, automatically by reference
check_context(['p', 'q', 'r'], [9, 8, 7]);

# Well, that tells us a lot...  Let's try rewriting our list comparison
# subroutine with this in mind

sub list_compare_2($$) {
    my ($a, $b) = @_;  # entire argument list is @_
    # Now that we know that scalar context of a reference is its address
    # in memory, the first thing we can check is if the references point
    # to the same location; if so, they are 'aliases' for the same exact
    # data structure so are by definition identical
    if ($a == $b) {
        print "references point to same location\n" if $verbose;
        return 1;
    }
    # The second comparison we should make is the lengths of the lists.
    if (@$a != @$b) {  # the comparison forces each of @$a and @$b into scalar context
        print "lists are different lengths\n" if $verbose;
        return 0;
    }
    # Now compare each element in turn; if any differ, return immediately
    for my $i (0 .. (@$a - 1)) {  # length of list @$a - 1
        if ($a->[$i] ne $b->[$i]) {  # use 'ne' to force string comparison
            print "element $i differs: a = '".$a->[$i]."' b = '".$b->[$i]."'\n" if $verbose;
            return 0;
        }
    }
    # if we get to the end of the loop, no elements differed
    print "lists are identical\n" if $verbose;
    return 1;
}
print "3a: for identical reference, list_compare_2() returns ".list_compare_2(\@x, \@x)."\n";
print "3b: for different lengths, list_compare_2() returns ".list_compare_2(['p', 'q', 'r', 's'], [9, 8, 7])."\n";
print "3c: for same length different lists, list_compare_2() returns ".list_compare_2(\@x, \@y)."\n";
my @z = @y;  # a copy of @y, but not an alias of @y
print "3d: for identical lists, list_compare_2() returns ".list_compare_2(\@y, \@z)."\n";


