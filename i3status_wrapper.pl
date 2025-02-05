#!/usr/bin/env perl

# This script is a simple wrapper which prefixes each i3status line with custom
# information. To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section.
# Then, in your ~/.i3/config, use:
#     status_command i3status | ~/i3status/contrib/wrapper.pl
# In the 'bar' section.

use strict;
use warnings;
# You can install the JSON module with 'cpan JSON' or by using your
# distribution’s package management system, for example apt-get install
# libjson-perl on Debian/Ubuntu.
use JSON;

# Don’t buffer any output.
$| = 1;

# Skip the first line which contains the version header.
print scalar <STDIN>;

# The second line contains the start of the infinite array.
print scalar <STDIN>;

# Read lines forever, ignore a comma at the beginning if it exists.
while (my ($statusline) = (<STDIN> =~ /^,?(.*)/)) {
    # Decode the JSON-encoded line.
    my @blocks = @{decode_json($statusline)};

    # Grab the current keyboard layout
    my $keyboard_layout = `setxkbmap -query | grep layout`;
    # Chads way of getting the keyboard layout
    $keyboard_layout = substr($keyboard_layout, 12, 2);

    # Since `date` is the last block...
    my $datetime_block = pop @blocks;

    push @blocks, {
        full_text => "󰌓 $keyboard_layout",
        name => "keyboard"
    };

    # Grab current battery
    my $battery_path = "/sys/class/power_supply/BAT0";
    if (-d $battery_path) {
        chomp(my $battery_charge_full = `cat $battery_path/charge_full`);
        chomp(my $battery_charge_now = `cat $battery_path/charge_now`);
        chomp(my $battery_status = `cat $battery_path/status`);
        my $battery_percentage = ((int($battery_charge_now) / int($battery_charge_full)) * 100);
        $battery_percentage = sprintf("%.2f", $battery_percentage) + 0;
        my $is_charging = $battery_status eq "Charging" ? 1 : 0;
        my $battery_icon;


        if ($is_charging) {
            my $battery_icon_map = {
                100 => "󰂅",
                90  => "󰂋",
                80  => "󰂊",
                70  => "󰢞",
                60  => "󰂉",
                50  => "󰢝",
                40  => "󰂈",
                30  => "󰂇",
                20  => "󰂆",
                10  => "󰢜",
                _   => "󰢟"
            };
            my $battery_percentage_step = int($battery_percentage - ($battery_percentage % 10));
            $battery_icon = $battery_icon_map->{$battery_percentage_step} || $battery_icon_map->{_};
        } else {
            if ($battery_percentage < 5) {
                $battery_icon = "󰂃";
            } else {
                my $battery_icon_map = {
                    100 => "󰁹",
                    90  => "󰂂",
                    80  => "󰂁",
                    70  => "󰂀",
                    60  => "󰁿",
                    50  => "󰁾",
                    40  => "󰁽",
                    30  => "󰁼",
                    20  => "󰁻",
                    10  => "󰁺",
                    _   => "󰂃"
                };
                my $battery_percentage_step = int($battery_percentage - ($battery_percentage % 10));
                $battery_icon = $battery_icon_map->{$battery_percentage_step} || $battery_icon_map->{_};
            }
        }

        push @blocks, {
            full_text => "$battery_icon $battery_percentage%",
            name => "battery"
        };
    }

    # Grab the current volume via Alsa
    my $current_volumes = `amixer get Master | grep -oP '\\d+%'`;
    my @volumes = split /\n/, $current_volumes;
    my $volume = 0;

    for my $vol (@volumes) {
        $vol =~ s/%//;
        $volume += $vol;
    }

    $volume = $volume / scalar @volumes;
    my $volume_icon = "󰖁";

    if ($volume > 0) {
        my $volume_icon_map = {
            4 => "󰕾",
            3 => "󰕾",
            2 => "󰖀",
            1 => "󰖀",
            0 => "󰕿"
        };
        my $volume_icon_step = int(($volume - ($volume % 25)) / 25);
        $volume_icon = $volume_icon_map->{$volume_icon_step};
    }

    push @blocks, {
        full_text => "$volume_icon  $volume%",
        name => "volume"
    };

    # Run the brightnessctl command and capture its output
    my $brightness = `brightnessctl`;
    # Match the pattern to extract the percentage
    if ($brightness =~ /Current brightness: \S+ \((\d+)%\)/) {
        # Store the matched percentage in a variable
        my $brightness_percentage = $1;
        my $brightness_icon_map = {
            100 => "󱩖",
            90  => "󱩖",
            80  => "󱩕",
            70  => "󱩔",
            60  => "󱩓",
            50  => "󱩒",
            40  => "󱩑",
            30  => "󱩐",
            20  => "󱩏",
            10  => "󱩎",
            _   => "󱩎"
        };
        my $brightness_percentage_step = int($brightness_percentage - ($brightness_percentage % 10));
        my $brightness_icon = $brightness_icon_map->{$brightness_percentage_step} || $brightness_icon_map->{_};

        # Prefix our own information (you could also suffix or insert in the middle).
        @blocks = ({
            full_text => " $brightness_icon brightness $brightness_percentage%",
            name => "brightness"
        }, @blocks);
    }

    # Check for running SSM sessions
    chomp(my $sessions_list = `ps -ef | grep "session-manager-plugin AWS_SSM_START_SESSION_RESPONSE" | grep -v grep`);

    unless ($sessions_list eq "") {
        # Splits the list by newline into an array
        my @sessions_list = split /\n/, $sessions_list;
        my $prod_sessions_count = 0;
        my $dev_sessions_count = 0;

        for my $session (@sessions_list) {
            # Replaces everything until the "StartSession " string with nothing (including the string)
            $session =~ s/.*StartSession //;

            # Replaces everything after the " " string with nothing (including the string)
            $session =~ s/ .*$//;
            chomp $session;

            # Checks if the session is a production session
            if ($session =~ /prod/) {
                $prod_sessions_count++;
            } elsif ($session =~ /dev/) {
                $dev_sessions_count++;
            }
        }
        
        unshift @blocks, {
            full_text => "  ssm [prod $prod_sessions_count] [dev $dev_sessions_count]",
            name => "aws_ssm"
        };
    }

    push @blocks, $datetime_block;

    push @blocks, {
        full_text => " ",
        name => "popos_logo"
    };

    # Output the line as JSON, making sure it keeps emojis and such intact.
    utf8::decode($_->{full_text}) for @blocks;
    print encode_json(\@blocks) . ",\n";
}