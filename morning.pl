#!/usr/bin/perl
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

sub print_good_morning_msg {
    my $quote_response = `curl -s "https://zenquotes.io/api/today"`;
    my @parsed_quote_response = @{decode_json($quote_response)};
    chomp(my $day_of_week = `date +%A`);

    my $temperature_response = `curl -s "https://api.open-meteo.com/v1/forecast?latitude=-29.36&longitude=-50.86&current=temperature_2m,wind_speed_10m"`;
    my $parsed_temperature_response = decode_json($temperature_response);
    my $temperature = $parsed_temperature_response->{current}->{temperature_2m};

    print "# Good morning!\n";
    print "# - Today is $day_of_week\n";
    print "# - The temperature is $temperature°C outside\n#\n";
    print "# Quote of the day:\n";
    print('# > ' . $parsed_quote_response[0]->{q});
    print "\n#\n";

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

    print "# Reminders:\n\n";
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
    system("vi $MORNING_BUFFER_FILE");
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

open(my $fh, '>>', $MORNING_BUFFER_FILE) or die "Failed to open $MORNING_BUFFER_FILE: $!";
print $fh "$message\n";
close $fh;
output_reminders();
