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

sub max_of {
    my @values = @_;
    my $max = $values[0];

    foreach my $value (@values) {
        if ($value > $max) {
            $max = $value;
        }
    }

    return $max;
}

sub min_of {
    my @values = @_;
    my $min = $values[0];

    foreach my $value (@values) {
        if ($value < $min) {
            $min = $value;
        }
    }

    return $min;
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

sub normalize_angle {
    my $a = shift;
    my @angles = (0, 45, 90, 135, 180, 225, 270, 315);
    my $min_diff = 360;
    my $normalized_angle = 0;

    foreach my $angle (@angles) {
        my $diff = abs($a - $angle);
        if ($diff < $min_diff) {
            $min_diff = $diff;
            $normalized_angle = $angle;
        }
    }

    return $normalized_angle;
}

my $BOLD_FG_ANSI = "\e[1m";
my $RESET_ANSI = "\e[0m";

sub bold_text {
    my $text = shift;
    return "$BOLD_FG_ANSI$text$RESET_ANSI";
}

sub print_good_morning_msg {
    chomp(my $current_temperature_response = `curl -s "https://api.open-meteo.com/v1/forecast?latitude=-29.36&longitude=-50.86&current=apparent_temperature,wind_speed_10m,wind_direction_10m,is_day"`);
    chomp(my $daily_forecast_response = `curl -s "https://api.open-meteo.com/v1/forecast?latitude=-29.36&longitude=-50.86&daily=apparent_temperature_min,apparent_temperature_max,weather_code,precipitation_probability_max,precipitation_probability_min"`);
    my $parsed_current_temperature_response = $current_temperature_response ? decode_json($current_temperature_response) : 0;
    my $parsed_daily_forecast_response = $daily_forecast_response ? decode_json($daily_forecast_response) : 0;
    chomp(my $day_of_week = `date +%A`);
    chomp(my $current_time = `date +%H:%M`);
    my $temperature;
    my $wind_speed;
    my $wind_direction;
    my $min_temperature;
    my $max_temperature;
    my $weather_code;
    my $precipitation_probability_max;
    my $precipitation_probability_min;
    my $is_day = $parsed_current_temperature_response ? $parsed_current_temperature_response->{current}->{is_day} : 0;

    unless ($parsed_current_temperature_response eq 0) {
        $temperature = $parsed_current_temperature_response->{current}->{apparent_temperature} . "°C";
        $wind_speed = $parsed_current_temperature_response->{current}->{wind_speed_10m} . "km/h";
        $wind_direction = $parsed_current_temperature_response->{current}->{wind_direction_10m};
        $wind_direction = normalize_angle($wind_direction);
    }

    unless ($parsed_daily_forecast_response eq 0) {
        $min_temperature = (min_of @{$parsed_daily_forecast_response->{daily}->{apparent_temperature_min}}) . "°C";
        $max_temperature = (max_of @{$parsed_daily_forecast_response->{daily}->{apparent_temperature_max}}) . "°C";
        my @precipitation_probability_max = @{$parsed_daily_forecast_response->{daily}->{precipitation_probability_max}};
        $precipitation_probability_max = $precipitation_probability_max[$#precipitation_probability_max];
        my @weather_code = @{$parsed_daily_forecast_response->{daily}->{weather_code}};
        $weather_code = $weather_code[$#weather_code];
    }

    # WMO Weather interpretation codes (WW)
    # Code	        Description
    # 0	            Clear sky
    # 1, 2, 3	    Mainly clear, partly cloudy, and overcast
    # 45, 48	    Fog and depositing rime fog
    # 51, 53, 55	Drizzle: Light, moderate, and dense intensity
    # 56, 57	    Freezing Drizzle: Light and dense intensity
    # 61, 63, 65	Rain: Slight, moderate and heavy intensity
    # 66, 67	    Freezing Rain: Light and heavy intensity
    # 71, 73, 75	Snow fall: Slight, moderate, and heavy intensity
    # 77	        Snow grains
    # 80, 81, 82	Rain showers: Slight, moderate, and violent
    # 85, 86	    Snow showers slight and heavy
    # 95 *	        Thunderstorm: Slight or moderate
    # 96, 99 *	    Thunderstorm with slight and heavy hail
    my %weather_icon_map = (
        0 => $is_day ? "󰖨" : "󰖔",
        1 => $is_day ? "󰖕" : "󰼱",
        2 => $is_day ? "󰖕" : "󰼱",
        3 => "󰖐",
        45 => "󰖑",
        48 => "󰖑",
        51 => "󰖒",
        53 => "󰖒",
        55 => "󰖒",
        56 => "󰖖",
        57 => "󰖖",
        61 => "󰖖",
        63 => "󰖖",
        65 => "󰖖",
        66 => "󰖖",
        67 => "󰖖",
        71 => "󰖘",
        73 => "󰖘",
        75 => "󰖘",
        77 => "󰙿",
        80 => "󰖖",
        81 => "󰖖",
        82 => "󰖖",
        85 => "󰖘",
        86 => "󰖘",
        95 => "󰙾",
        96 => "󰙾",
        99 => "󰙾"
    );
    my %weather_code_label_map = (
        0 => "Clear sky",
        1 => "Mainly clear",
        2 => "Partly cloudy",
        3 => "Overcast",
        45 => "Fog",
        48 => "Depositing rime fog",
        51 => "Drizzle",
        53 => "Drizzle",
        55 => "Drizzle",
        56 => "Freezing Drizzle",
        57 => "Freezing Drizzle",
        61 => "Rain",
        63 => "Rain",
        65 => "Rain",
        66 => "Freezing Rain",
        67 => "Freezing Rain",
        71 => "Snow fall",
        73 => "Snow fall",
        75 => "Snow fall",
        77 => "Snow grains",
        80 => "Rain showers",
        81 => "Rain showers",
        82 => "Rain showers",
        85 => "Snow showers",
        86 => "Snow showers",
        95 => "Thunderstorm",
        96 => "Thunderstorm",
        99 => "Thunderstorm"
    );
    my $weather_icon = $weather_icon_map{$weather_code};
    my $weather_label = $weather_code_label_map{$weather_code};

    open(my $fortune_fh, '-|', 'fortune') or die "Failed to run fortune: $!";
    my @fortune_lines = <$fortune_fh>;
    close $fortune_fh;
    chomp(my $fortune = join("", @fortune_lines));
    open(my $cowsay_fh, '|-', 'cowsay', '-f', 'dragon') or die "Failed to run cowsay: $!";
    print $cowsay_fh $fortune;
    close $cowsay_fh;

    println bold_text "\nGood morning!";
    print "\n";

    printdefln $current_time, "󰱆 Today is $day_of_week";
    printdefln $current_time, "  󰅐 It is now $current_time";
    printdefln $weather_icon, "$weather_icon The current weather is: $weather_label";
    printdefln $temperature, "󱃃 The temperature is $temperature outside (min/max $min_temperature/$max_temperature)";
    printdefln $precipitation_probability_max, "  󰦰 Precipitation chance is $precipitation_probability_max%";

    printdefln $wind_speed, "󰶥 Wind speed is $wind_speed";
    if (defined $wind_direction) {
        my $wind_direction_map = {
            0 => "North",
            45 => "Northeast",
            90 => "East",
            135 => "Southeast",
            180 => "South",
            225 => "Southwest",
            270 => "West",
            315 => "Northwest"
        };
        my %wind_direction_icon = (
            0 => "↑",
            45 => "↗",
            90 => "→",
            135 => "↘",
            180 => "↓",
            225 => "↙",
            270 => "←",
            315 => "↖"
        );
        my $wind_direction_icon = $wind_direction_icon{$wind_direction};
        $wind_direction = lc $wind_direction_map->{$wind_direction};
        println "  $wind_direction_icon Wind is blowing $wind_direction";
    }

    print "\n";

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
