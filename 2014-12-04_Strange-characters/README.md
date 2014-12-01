## Perl Hacks: Handling strange characters

What to do when we encounter strange characters, or what could be strange characters, in output:

```
$ cat contains-strange-characters.out
# ID 90_X
C C C  C A
# ID 76_X
G T T T C A
# ID 59_X
G C C  T
```

Looks like we have two spaces in a few of those lines.  Let's grep for that.

```
$ grep '  ' contains-strange-characters.out
$
```

Nothing found... hmmm well this tells us that what we see isn't what is really there.  We already know that we don't see newlines "\n", nor do we see tabs "\t", though we do see their effects.  We use `od -c` (**o**ctal **d**ump as **c**haracters) to see the literal contents of the file.

```
$ od -c contains-strange-characters.out
0000000    #       I   D       9   0   _   X  \n   C       C       C
0000020   \0       C       A  \n   #       I   D       7   6   _   X  \n
0000040    G       T       T       T       C       A  \n   #       I   D
0000060        5   9   _   X  \n   G       C       C      \0       T
0000100   \0  \n
0000102
```

We see the newlines, where we expect them to be, but what are those `\0` doing there?  That is an 'octal' (base-8) code for a literal zero value.  It turns out that `fastPhase` is using literal zeroes to indicate missing data.  We want to turn these into `N`.

Turning again to the output of `od -c`, some `\0` are sitting between two spaces, maybe that is why the `grep` didn't work.  So let's try grepping for those.

```
$ grep '\0' contains-strange-characters.out
Binary file contains-strange-characters.out matches
```

Strange, `grep` thinks we are grepping a binary file.  It's the `\0` that is making grep think that!  So let's force grep to treat this "binary" file as if it were a text file: 
 
```
$ grep -a '\0' contains-strange-characters.out
# ID 90_X
```

Well that's not what we want, our `'\0'` regular expression is just making `grep` match a literal zero.  If we force `grep` to recognize Perl regular expressions, then we have a way of specifying a literal zero.  With Gnu grep this option is `grep -P`, on Mac default grep it is `grep -p`.

```
$ grep -aP '\x0' contains-strange-characters.out
C C C  C A
G C C  T
```

This matches the lines containing `\0`; that last line contain two `\0` characters.

### What if we want to do this in Perl?

To see any strange characters that might be lurking within Perl lines, we might be able to use our new friend `Data::Dumper` or its nicer version `Data::Dumper::Perltidy`.  We'll start with a simplified version of the [`convert-fastPHASE.pl`](https://github.com/douglasgscofield/EBC-Perl-Hacks/tree/master/2014-10-02_Convert-fastPHASE-output) script from our very first meeting.

```perl
#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper::Perltidy;

while (<>) {
    chomp;
    next if not /^# ID +([^ ]+)/;
    my $id = $1;
    my $h1 = <>;
    chomp $h1;
    print STDERR Dumper($h1);
    $h1 =~ s/ //g;
    print ">$id\n";
    print "$h1\n";
}
```

produces output that is still missing the `\0` character.

```
$ ./convert-strange-characters.pl contains-strange-characters.out
$VAR1 = 'C C C  C A';
>90_X
CCCCA
$VAR1 = 'G T T T C A';
>76_X
GTTTCA
$VAR1 = 'G C C  T ';
>59_X
GCCT
```

Upon firther googling, we see from <http://search.cpan.org/~smueller/Data-Dumper-2.154/Dumper.pm> that there is a configuration variable for the module that allows us to see hidden characters called `$Data::Dumper::Useqq`.  Some modules have these variables, and they can change the behaviour of the module in very useful ways.  Now following the documentation, we just have to set this variable to 1.  The syntax for accessing a module variable is a little strange-looking at first, but just think of the variable having a prefix that is the name of its module.

```perl
$Data::Dumper::Useqq = 1;
```

Now our output is a little different, but definitely useful!

```
$ ./convert-strange-characters.pl contains-strange-characters.out
$VAR1 = "C C C \0 C A";
>90_X
CCCCA
$VAR1 = "G T T T C A";
>76_X
GTTTCA
$VAR1 = "G C C \0 T \0";
>59_X
GCCT
```

This also shows us how Perl represents this character, as `\0`.  So now we use the `tr///` (translation or transliteration) operator to change character(s) of one type, between the left pair `//`, into the corresponding character(s) between the right pair `//`.  For example to convert all (and only) a, c, t, g to uppercase:

    $string =~ tr/atcg/ATCG/;

We can use this for our character in question to convert them to `N`

    $h1 =~ tr/\0/N/;

The output of 

```perl
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
```

is now what we were looking for:

```
$ ./convert-strange-characters.pl contains-strange-characters.out
>90_X
CCCNCA
>76_X
GTTTCA
>59_X
GCCNTN
```
