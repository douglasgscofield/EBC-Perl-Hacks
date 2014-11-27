EBC-Perl-Hacks
==============

Repository for the Perl Hacks meeting group Thursdays 12.30-13.30 in the Evolutionary Biology Centre at Uppsala University

## 2014-10-02

We covered converting output from the [fastPHASE](http://stephenslab.uchicago.edu/software.html#fastphase) software package into a Fasta-like format with two 0101 sequences per sample.

## 2014-10-09

We covered merging two files where the keys are merged from two columns.  The Linux tool `join` can also be very helpful for many file merging operations.

## 2014-10-23

We covered parsing a [VCF file](http://www.1000genomes.org/wiki/analysis/variant%20call%20format/vcf-variant-call-format-version-41) and producing site-specific means of the `DP` field from the genotypes of specific samples.  This script has the bones of a VCF file parser, and includes several nice little uses of hashes and slices to ease coding.

We also covered a few ways of [splitting a string into characters](https://github.com/douglasgscofield/EBC-Perl-Hacks/blob/master/2014-10-23_Processing-VCF-file/splitting-a-string-into-characters.pl).

## 2014-10-30

We covered an introduction to BioPerl, and along with it a light introduction to Perl objects and references.  Several other scripts in other repositories here also use BioPerl.

* [`convertSequence.pl`](https://raw.githubusercontent.com/douglasgscofield/EBC-Perl-Hacks/master/2014-10-30_Intro-to-BioPerl/convertSequence.pl) is a BioPerl script for converting between different sequence formats.  The sequence formats BioPerl understands (for the `-f` and `-of` options of the script) are listed in the **Name** column of [this table](http://www.bioperl.org/wiki/HOWTO:SeqIO#Formats).
* [`convertAlignment.pl`](https://raw.githubusercontent.com/douglasgscofield/EBC-Perl-Hacks/master/2014-10-30_Intro-to-BioPerl/convertAlignment.pl) is a BioPerl script for converting between different alignment formats.  The alignment formats BioPerl understands (for the `-f` and `-of` options) are listed in the **Format** column of [this table](http://www.bioperl.org/wiki/HOWTO:AlignIO_and_SimpleAlign#AlignIO).  Note the caveat below the table, that only a subset of formats are available for output.

You can see from the scripts that doing this sort of operation with BioPerl is super-simple.

## 2014-11-06

We covered handling command line arguments using `Getopt::Std` and `Getopt::Long`, and also used an example of 'here' documents.

## 2014-11-20

We started to introduce Perl references, focusing on references to data structures.  Our first topic was improving efficiency by passing large arguments to subroutines as references, and then we looked at how references are "hiding in plain site", for example the subhashes being references to anonymous hashes in a hash-of-hashes.  And we introduced the concept of "anonymous" (unnamed) data structures that are accessed only via reference.

We also use the `Data::Dumper` module to examine Perl data structures, and showed how its output is different if we pass a reference to the data structure or the data structure itself.

## 2014-11-27

We started by installing `Data::Dumper::Perltidy` using `cpan` and switching to
its more compact format for printing data structures.  We continued by
discussing scalar and list context in Perl.  This is a central concept in Perl
and having an understanding of context is necessary for understanding some subtle
and/or tricky things about the language.

We then looked at references passed as arguments, and what scalar context means
to a reference (`scalar($a)`), and to a reference cast to a list (`scalar(@$a)`).
We used these features to write a simple subroutine comparing two lists.
