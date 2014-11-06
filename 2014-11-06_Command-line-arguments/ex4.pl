#!/usr/bin/env perl

# Demonstrates using Getopt::Long's GetOptions(),
# using 'here' documents to produce output (see usage)
# and use of __END__ 

use strict;
use warnings;

use Getopt::Long;

my $opt_string = "";
my $opt_integer= 0;
my $opt_float = 0.0;
my $opt_verbose = 1;
my $opt_help = 0;

sub usage() {
    print STDERR << "__USAGE__";

How to use $0 :

-s | --string string   : specify string value [default value is "$opt_string"]
-i | --integer integer : specify integer file [default value is $opt_integer]
-f | --float float     : specify float file [default value is $opt_float]
-v | --verbose         : be verbose [default value is $opt_verbose]
-q | --quiet           : be quiet, sets verbose to 0
-? | -h | --help       : get this help message

__USAGE__
    exit 1;
}


print STDERR "Command-line arguments BEFORE GetOptions:: ", join(" , ", @ARGV), "\n";

GetOptions("string=s"  => \$opt_string,
           "integer=i" => \$opt_integer,
           "float=f"   => \$opt_float,
           "verbose"   => \$opt_verbose,
           "quiet"     => sub { $opt_verbose = 0 },
           "help|?"    => \$opt_help) 
or usage();

print STDERR "Command-line arguments AFTER GetOptions :: ", join(" , ", @ARGV), "\n";

usage() if $opt_help;

# Perl ignores everything in the file after __END__

__END__

aölsdkjfpoqiuewrjölkzsncvpoiawyuerölakjdf naowieur lqiudyf hvlzosödiyf piu

while (<>) {
    if ($options{v}) {
        print $options{p} if $options{p};
        print;
    }
}
