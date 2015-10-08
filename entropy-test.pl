#!/usr/bin/perl

## OpenSSL Entropy Test ##
use strict;
use warnings;
use Term::ANSIColor;

my $iterations = 10;
my $random = `openssl rand -hex 1`;

# Random numbers will increment the corresponding bucket
my %buckets = ();
my $tooHigh = 15;
my $tooLow = 5;

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
my $i = 0;
while (my ($key, $value) = each(%buckets)) {
    if ($value > $tooHigh) {
        print color "bold red";
        print "$key => $value : ";
        print color "reset";
    } elsif ($value < $tooLow) {
        print color "bold blue";
        print "$key => $value : ";
        print color "reset"
    } else {
        print "$key => $value : ";
    }

    print LOG "$key => $value : ";
    if ($i % 8 == 0 ) {
        print "\n";
        print LOG "\n";
    }
    $i++;
}

print "\n";
close LOG;

