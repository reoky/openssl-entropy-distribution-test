#!/usr/bin/perl

## OpenSSL Entropy Test ##

use strict;
use warnings;

my $iterations = 100000;
my $random = `openssl rand -hex 1`;

# Random numbers will increment the corresponding bucket
my %buckets = ();

# Build a distribution
for (my $i = 0; $i < $iterations; $i++) {
    my $random = `openssl rand -hex 1`;
    chomp $random;
    $buckets{$random} = ++$buckets{$random} || 0;
    if ($i % 100 == 0) { print "$i/$iterations\n"; }
}

# Open a log file
open(LOG, ">", "entropy.log");

# Print the distribution out 0-FF (255)
while (my ($key, $value) = each(%buckets)) {
    print "$key => $value\n";
    print LOG "$key => $value\n";
}

close LOG;
