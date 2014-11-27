## Perl Hacks: References 2

Before we dig back into Perl references, we will cover a couple of necessary preliminaries.

### `Data::Dumper::Perltidy`

We will continue to use the `Dumper()` function to display data structures, but we will use a different module with an identical interface which prints more compactly.  We have been using the `Data::Dumper` module.

```perl
use Data::Dumper;
my @alph = qw/a b c d e f g h i j k l m n o p q r s t u v w x y z/;
my %j;
$j{a} = [ 1, 2, 3 ];
$j{b} = [ @alph[0..3] ];
print Dumper(\%j);
```

produces

~~~~
$VAR1 = {
          'b' => [
                   'a',
                   'b',
                   'c',
                   'd'
                 ],
          'a' => [
                   1,
                   2,
                   3
                 ]
        };
~~~~

From now on we will use the module `Data::Dumper::Perltidy`, which can be installed using `cpan`.

```bash
emp051-171: ~/perl-hacks $ sudo cpan
Terminal does not support AddHistory.

cpan shell -- CPAN exploration and modules installation (v2.05)
Enter 'h' for help.

cpan[1]> install Data::Dumper::Perltidy
...
*lots of output*
...
  JMCNAMARA/Data-Dumper-Perltidy-0.03.tar.gz
  sudo /usr/bin/make install  -- OK

cpan[2]> quit
```

and replace `Data::Dumper` with `Data::Dumper::Perltidy` in our script.  That's the only change required; the function named `Dumper()` is still used to print data structures.

```perl
use Data::Dumper::Perltidy;
print Dumper(\%j);
```

produces output that is more compact and easier to read:

~~~~
$VAR1 = {
    'a' => [ 1,   2,   3 ],
    'b' => [ 'a', 'b', 'c', 'd' ]
};
~~~~

### A brief review of scalar and list contexts...

Perl values are used in either scalar (single value) or list (one or more values) contexts.  This means that, in list context a scalar value will be treated as if it is a list of length 1, and conversely in scalar context a list will be treated as if it provides a single value, which is generally its length.  This is a fundamental concept within Perl, and one which Perl books spend quite a bit of time covering.  Scalar context can be "forced" on a list with `scalar()`, which is one way to get its length:

```perl
print "The length of the \@alph array is ".scalar(@alph)."\n";
```

Note that we deactivate the meaning of `@` for accessing the value of the list `@alph` by 'escaping' it with backslash within the string, `\@alph`.  This also works for `$`.  The escape is not necessary within strings delimited with single quotes, because Perl does not perform value substitution.  So an alternate way to write the above line would be

```perl
print 'The length of the @alph array is '.scalar(@alph)."\n";
```

Within strings, the context used is generally the "natural" one for the data type.  If we perform substitution on a list within a string, the list is expanded into its values separated by spaces:

```perl
my @s = @alph[0..3];
print "The contents of \@s are '@s'\n";
```

results in

~~~~
The contents of @s are 'a b c d'
~~~~


In R, values are readily promoted to vector or matrix (multidimensional vector) context.  A comparison of a scalar to a vector produces a vector of comparison results:

```R
> 3 == 2:4
[1]  FALSE  TRUE FALSE
```

In Perl comparisons always occur in scalar context, so comparing a scalar to a list is a comparison against the scalar value of the list, its length:

```Perl
print "\@alph has more than 17 elements\n" if @alph > 17;
```

A comparison of two lists is a comparison of their lengths, not their contents, as we will soon see.

### Back to Perl references

Let's write a little function that compares two lists and returns 1 if their contents are identical and 0 if not.  We can easily imagine situations when we might want to do this, and though there are other solutions to this which I will show you later, we don't know about those yet.

We already know that passing two lists by value as arguments to a function generally shouldn't be done; instead we should use references.

```perl
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
    print "lists are the same length\n" if $verbose;
    return 1;
}
my @x = 1..3;
my @y = qw/a b c/;
# The length of both lists is 3, so list_compare_1() should return 1, right?
print "1a: list_compare_1() returns ".list_compare_1(\@x, \@y)."\n";
# What if we pass two anonymous arrays, both also length 3:
print "1b: list_compare_1() returns ".list_compare_1(['p', 'q', 'r'], [9, 8, 7])."\n";
```

produces

~~~~
$VAR1 = [ 1, 2, 3 ];
$VAR1 = [ 'a', 'b', 'c' ];
lists are different lengths
1a: list_compare_1() returns 0
$VAR1 = [ 'p', 'q', 'r' ];
$VAR1 = [ 9, 8, 7 ];
lists are different lengths
1b: list_compare_1() returns 0
~~~~

So there is something here we don't understand.  Let's check the context of references
more explicitly.

```perl
sub check_context($$) {
    my ($a, $b) = @_;
    print "reference \$a in scalar context is '".scalar($a)."'\n";
    print "reference \$b in scalar context is '".scalar($b)."'\n";
    print "reference \$a in 'string' context is '$a'\n";
    print "reference \$b in 'string' context is '$b'\n";
    print "reference \$a cast to an array '\@{\$a}' in 'string' context is '@{$a}'\n";
    print "reference \$b cast to an array '\@{\$b}' in 'string' context is '@{$b}'\n";
    print "reference \$a cast to an array '\@\$a' in 'string' context is '@$a'\n";
    print "reference \$b cast to an array '\@\$b' in 'string' context is '@$b'\n";
    print "reference \$a cast to an array '\@\$a' in scalar context is '".scalar(@$a)."'\n";
    print "reference \$b cast to an array '\@\$b' in scalar context is '".scalar(@$b)."'\n";
}
check_context(\@x, \@y);
```

produces

~~~~
reference $a in scalar context is 'ARRAY(0x7fa8d231b0f8)'
reference $b in scalar context is 'ARRAY(0x7fa8d2304660)'
reference $a in 'string' context is 'ARRAY(0x7fa8d231b0f8)'
reference $b in 'string' context is 'ARRAY(0x7fa8d2304660)'
reference $a cast to an array '@{$a}' in 'string' context is '1 2 3'
reference $b cast to an array '@{$b}' in 'string' context is 'a b c'
reference $a cast to an array '@$a' in 'string' context is '1 2 3'
reference $b cast to an array '@$b' in 'string' context is 'a b c'
reference $a cast to an array '@$a' in scalar context is '3'
reference $b cast to an array '@$b' in scalar context is '3'
~~~~

Calling it with the anonymous arrays produces the same sort of output:

```perl
check_context(['p', 'q', 'r'], [9, 8, 7]);
```

~~~~
reference $a in scalar context is 'ARRAY(0x7fa8d248a2b0)'
reference $b in scalar context is 'ARRAY(0x7fa8d248a658)'
reference $a in 'string' context is 'ARRAY(0x7fa8d248a2b0)'
reference $b in 'string' context is 'ARRAY(0x7fa8d248a658)'
reference $a cast to an array '@{$a}' in 'string' context is 'p q r'
reference $b cast to an array '@{$b}' in 'string' context is '9 8 7'
reference $a cast to an array '@$a' in 'string' context is 'p q r'
reference $b cast to an array '@$b' in 'string' context is '9 8 7'
reference $a cast to an array '@$a' in scalar context is '3'
reference $b cast to an array '@$b' in scalar context is '3'
~~~~

Scalar context of a reference is an *address*: the actual location within
your computer's memory of the data structure the reference is pointing to.  And
Perl shows us this address: pretty cool huh?  When we were comparing the
references in `list_compare_1()` above, we were actually comparing the
*addresses* of the lists, rather than the lengths of the lists.  No wonder it
didn't work.

So now we see the way to get the length of the array a reference points to is
to cast the reference to array, and then put that into scalar context:

    scalar(@{ $a })
    scalar(@$a)

Let's put our knowledge to work on a new version of `list_compare()`:

```perl
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
```

Running this gives us

~~~~
references point to same location
3a: for identical reference, list_compare_2() returns 1
lists are different lengths
3b: for different lengths, list_compare_2() returns 0
element 0 differs: a = '1' b = 'a'
3c: for same length different lists, list_compare_2() returns 0
lists are identical
3d: for identical lists, list_compare_2() returns 1
~~~~

which is what we were hoping for.
