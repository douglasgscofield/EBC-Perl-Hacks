#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my @alph = qw/a b c d e f g h i j k l m n o p q r s t u v w x y z/;

# Passing an array as an argument to a subroutine.

# We can pass an array "by value", Perl unrolls to its individual scalar
# elements and they arrive as individual arguments.  If the array contains 3
# million values, passing it by value adds 3 million arguments to the
# subroutine call.  The only "safe" way to pass an array by value in a mixed
# argument list is to pass it as the last argument.

sub p($@) {
    my $i = shift;
    my @a = @_;  # grab whatever arguments are left
    print STDERR $a[$i],"\n";  # access like a "normal" array
}
p(3, @alph);  # pass the array by *value*

# We can pass an array "by reference".  Perl passes a single scalar
# argument which represents a reference to ("the address of") the array,
# rather than the individual elements.  A single scalar value is passed
# no matter how large the array is (3 elements, or 3 million).  References
# can safely appear anywhere in the argument list.
#
# We need to tell Perl what the reference is pointing to.  In some cases
# Perl can guess (we use 'shift' on an array reference), in other cases
# the syntax is a little different.  We can "cast" the reference to an array by
# wrapping it with @{ } (or to a hash with %{ }, etc.) and then using it as if
# it were originally declared an array.  Or we can use "points to" syntax "->"
# together with familiar [ ] (or { }, etc.) to indicate the reference "points
# to" an array (or a hash, etc.)

sub r($$) {
    my $i = shift;
    my $a = shift;
    # we must use different syntax because $a is a reference
    print STDERR @{$a}[$i],"\n";  # tell Perl $a is an array reference
    print STDERR $a->[$i],"\n";  # (I think) a clearer way to tell Perl
}
r(3, \@alph);  # pass the array by *reference*


# Now look at a hash of hashes.  The subhashes are stored as references
# to anonymous hashes.

my %h;

$h{a}{1} = "yes";
$h{a}{2} = "maybe";
$h{a}{3} = "no";

# Like arrays, hashes can also be passed by value.  This unrolls the hash into
# a list with successive elements being a key, its value, a key, its value,
# etc.  Data::Dumper makes this clear.  The second value in the list in this
# case is the anonymous hash which contain 1 => "yes", 2 => "maybe", and 3 =>
# "no".
print Dumper(%h);
# When we pass the hash-of-hashes by reference, its existence as a single hash 
# is preserved.
print Dumper(\%h);


# Now anonymous arrays, stored by reference in a hash.  Sounds complicated, but
# it really isn't.

# First create a hash with values that are anonymous arrays
my %j;
$j{a} = [ 1, 2, 3 ];   # square brackets create an anonymous array
$j{b} = [ @alph[0..3] ];  # fill the array with a slice
print Dumper(\%j);

# Manipulate the anonymous arrays using standard array operations like shift
my $a = shift @{$j{a}};  # explicitly saying $j{a} is a reference to an array
my $b = shift $j{b};  # here Perl knows $j{b} is a reference to an array
print $a, "\n";
print $b, "\n";
push @{$j{a}}, 1001;  # push being explicit
push $j{b}, "Å";  # push trusting Perl to know $j{b} is a reference to an array

$j{p} = [ @alph[0..3] ];
$j{q} = [ @alph[7..12] ];
$j{r} = [ @alph[17..19] ];
print Dumper(\%j);

