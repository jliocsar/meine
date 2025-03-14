#!/usr/bin/env perl
use strict;
use warnings;

use Getopt::Long;
use JSON;

my $good_morning_flag;
my $output_flag;
my $edit_flag;
my $rc_flag;
my $cron_flag;
GetOptions(
    # "length=i" => \$length, # numeric
    # "file=s" => \$data, # string
    "edit" => \$edit_flag,
    "gm" => \$good_morning_flag,
    "sh" => \$rc_flag,
    "cron" => \$cron_flag,
    "output" => \$output_flag
) or die("Error in command line arguments\n");

my $HOME = $ENV{HOME};
my $MORNING_DIR = "$HOME/.my-morning";
my $MORNING_BUFFER_FILE = "$MORNING_DIR/buffer.txt";

if ($cron_flag) {
    my $cache_value = 1;
    open(my $fh, '>', "$MORNING_DIR/cron.txt") or die "Failed to open $MORNING_DIR/cron.txt: $!";
    print $fh $cache_value;
    close $fh;
    exit 0;
}

unless (-d $MORNING_DIR) {
    mkdir $MORNING_DIR or die "Failed to create $MORNING_DIR: $!";
}

sub println {
    my $message = shift;
    print "$message\n";
}

sub printdefln {
    my $var = shift;
    my $msg = shift;
    if (defined $var) {
        println($msg);
    }
}

my $BOLD_FG_ANSI = "\e[1m";
my $RESET_ANSI = "\e[0m";

sub bold_text {
    my $text = shift;
    return "$BOLD_FG_ANSI$text$RESET_ANSI";
}

sub print_good_morning_msg {
    unless (-e $MORNING_BUFFER_FILE) {
        exit 0;
    }

    open(my $fh, '<', $MORNING_BUFFER_FILE) or die "Failed to open $MORNING_BUFFER_FILE: $!";
    my @lines = <$fh>;
    close $fh;
    chomp(my $message = join("", @lines));

    if ($message eq "") {
        exit 0;
    }

    @lines = grep { $_ ne "\n" } @lines;
    my $lines_count = scalar @lines;
    println bold_text "Reminders ($lines_count):\n";
    print $message;
    print "\n";
}

if ($rc_flag) {
    if (-e "$MORNING_DIR/cron.txt") {
        chomp(my $cache_value = `cat $MORNING_DIR/cron.txt`);
        if ($cache_value == 1) {
            print_good_morning_msg();
        }
        unlink "$MORNING_DIR/cron.txt";
    }
    exit 0;
}

if ($good_morning_flag) {
    print_good_morning_msg();
    exit 0;
}

if ($edit_flag) {
    system("nvim $MORNING_BUFFER_FILE");
    exit 0;
}

sub output_reminders {
    unless (-e $MORNING_BUFFER_FILE) {
        exit 0;
    }

    open(my $fh, '<', $MORNING_BUFFER_FILE) or die "Failed to open $MORNING_BUFFER_FILE: $!";
    my @lines = <$fh>;
    close $fh;
    my $message = join("", @lines);
    print $message;
}

if ($output_flag) {
    output_reminders();
    exit 0;
}

chomp(my $message = join(" ", @ARGV));
if ($message eq "") {
    output_reminders();
    exit 0;
}

if ($message eq "edit") {
    println "Did you mean --edit?";
    exit 0;
}

open(my $fh, '>>', $MORNING_BUFFER_FILE) or die "Failed to open $MORNING_BUFFER_FILE: $!";
print $fh "$message\n";
close $fh;
output_reminders();
