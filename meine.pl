#!/usr/bin/perl
use strict;
use warnings;

my $op_type = $ARGV[0];
unless (defined $op_type) {
    print "Usage: meine <sync|open>\n";
    exit 1;
}

my $HOME = $ENV{HOME};
my $ROOT = "$HOME/.meine";

# Asserts that the "$HOME/.meine" folder exists
sub assert_meine {
    unless (-e $ROOT) {
        print "Root directory $ROOT does not exist\n";
        exit 1;
    }
}

sub meine_sync {
    assert_meine();
    `cd $ROOT && git add . && git commit -m 'sync' && git push`;
    exit 0;
}

sub meine_open {
    assert_meine();
    `code $ROOT`;
    exit 0;
}

if ($op_type eq "sync") {
    meine_sync();
} elsif ($op_type eq "open") {
    meine_open();
} else {
    print "Invalid operation type\n";
    exit 1;
}
