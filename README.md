EBC-Perl-Hacks
==============

Repository for the Perl Hacks meeting group Thursdays 12.30-13.30 in the Evolutionary Biology Centre at Uppsala University


## 2014-10-02

* Introduction to basic text processing in Perl by...
* Converting output from the [fastPHASE](http://stephenslab.uchicago.edu/software.html#fastphase) software package into a Fasta-like format with two 0101 sequences per sample


## 2014-10-09

* Column-based text processing in Perl by...
* Merging two files where the keys are merged from two columns
* The Linux tool `join` can also be very helpful for many file merging operations.


## 2014-10-23

* Much more complex text processing in Perl by...
* Parsing a [VCF file](http://www.1000genomes.org/wiki/analysis/variant%20call%20format/vcf-variant-call-format-version-41) and producing site-specific means of the `DP` field from the genotypes of specific samples
* The script has the bones of a VCF file parser
* The script includes several nice little uses of hashes and slices to ease coding.
* A few ways of [splitting a string into characters](https://github.com/douglasgscofield/EBC-Perl-Hacks/blob/master/2014-10-23_Processing-VCF-file/splitting-a-string-into-characters.pl).


## 2014-10-30

* Introduction to BioPerl
* Very light introduction to Perl objects and references (much more later!)
* [`convertSequence.pl`](https://raw.githubusercontent.com/douglasgscofield/EBC-Perl-Hacks/master/2014-10-30_Intro-to-BioPerl/convertSequence.pl) is a BioPerl script for converting between different sequence formats.  The sequence formats BioPerl understands (for the `-f` and `-of` options of the script) are listed in the **Name** column of [this table](http://www.bioperl.org/wiki/HOWTO:SeqIO#Formats).
* [`convertAlignment.pl`](https://raw.githubusercontent.com/douglasgscofield/EBC-Perl-Hacks/master/2014-10-30_Intro-to-BioPerl/convertAlignment.pl) is a BioPerl script for converting between different alignment formats.  The alignment formats BioPerl understands (for the `-f` and `-of` options) are listed in the **Format** column of [this table](http://www.bioperl.org/wiki/HOWTO:AlignIO_and_SimpleAlign#AlignIO).  Note the caveat below the table, that only a subset of formats are available for output.
* The scripts demonstrate how simple working with BioPerl can be


## 2014-11-06

* Simple command line arguments with `Getopt::Std`
* Much more complex command line arguments with `Getopt::Long`
* An example of 'here' documents


## [2014-11-20](https://github.com/douglasgscofield/EBC-Perl-Hacks/blob/master/2014-11-20_Intro-to-references/references.pl)

* Introduction to Perl references to data structures
* It is much more efficient to pass a large data structure by reference than by value
* References are 'hiding in plain sight' in Perl (e.g., subhashes in hash-of-hashes), it helps to recognize them
* "anonymous" (unnamed) data structures that are accessed only via reference
* Introduction to the standard `Data::Dumper` module to examine Perl data structures
* How `Data::Dumper` output is different if we pass a reference to the data structure or the data structure itself


## [2014-11-27](https://github.com/douglasgscofield/EBC-Perl-Hacks/tree/master/2014-11-27_Scalar-context-and-references-2)

* Installing `Data::Dumper::Perltidy` using `cpan` and switching to its more compact format for printing data structures
* Scalar and list context.  Having an understanding of context is necessary for understanding some subtle and/or tricky things about the language.
* Becoming more comfortable passing references as arguments to subroutines
* What scalar context means to a reference (`scalar($a)`)
* What scalar context means to a reference cast to a list (`scalar(@$a)`)
* Writing a simple subroutine comparing two lists, with the lists passed as references


## [2014-12-04](https://github.com/douglasgscofield/EBC-Perl-Hacks/tree/master/2014-12-04_Strange-characters)

* Detecting strange ('control') characters in output using command-line tools, and how to `grep` for them
* How to detect and manage strange characters in Perl

