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

# Define some constants
my %Color = (
    Default => undef,
    Good => "#82BF8C",
    Bad => "#E56A54",
    Healthy => "#65c1d8",
    Unhealthy => "#E5C07B",
    Muted => "#999999"
);

my $has_connection_to_internet;

# Read lines forever, ignore a comma at the beginning if it exists.
while (my ($statusline) = (<STDIN> =~ /^,?(.*)/)) {
    # Decode the JSON-encoded line.
    my @blocks = @{decode_json($statusline)};

    # We'll just add icons to the CPU temperature block
    # Since we just need the index to do that, we already use the loop from the `tztime` block to try and find this one;
    # If it still doesn't find it, it'll re-iterate over all blocks again, starting from the last index it got to.
    my $cpu_temp_block_idx;

    # Since `date` has to be the last block...
    my $datetime_block;
    my $datetime_block_idx = 0;

    for my $idx (0..$#blocks) {
        my $block_name = $blocks[$idx]->{name};
        if ($block_name eq "cpu_temperature") {
            $cpu_temp_block_idx = $idx;
        }
        if ($block_name eq "tztime") {
            $datetime_block_idx = $idx;
            $datetime_block = $blocks[$idx];
            last;
        }
    }

    splice @blocks, $datetime_block_idx, 1;

    unless (defined $cpu_temp_block_idx) {
        for my $idx ($datetime_block_idx + 1..$#blocks) {
            if ($blocks[$idx]->{name} eq "cpu_temperature") {
                $cpu_temp_block_idx = $idx;
                last;
            }
        }
    }

    my $cpu_temp = $blocks[$cpu_temp_block_idx]->{full_text};
    if ($cpu_temp =~ /(\d+)/) {
        $cpu_temp = int($1);

        my $cpu_temp_icon;

        if ($cpu_temp > 95) {
            $cpu_temp_icon = "󱪃";
        } elsif ($cpu_temp > 85) {
            $cpu_temp_icon = "󰸁";
        } else {
            $cpu_temp_icon = "󰔏";
        }

        utf8::decode($cpu_temp_icon);
        $blocks[$cpu_temp_block_idx]->{full_text} = "$cpu_temp_icon " . $blocks[$cpu_temp_block_idx]->{full_text};
    }

    # Replace the wifi block with a custom one
    my $wifi_block_idx = 0;
    my $wifi_block;
    for my $idx (0..$#blocks) {
        if ($blocks[$idx]->{name} eq "wireless") {
            $wifi_block_idx = $idx;
            $wifi_block = $blocks[$idx];
            last;
        }
    }
    splice @blocks, $wifi_block_idx, 1;

    my $wifi_percentage = $wifi_block->{full_text};

    if ($wifi_percentage =~ /(\d+)%/) {
        $wifi_percentage = int($1);

        chomp(my $wifi_id = `iwgetid -r`);
        chomp(my $is_wifi_protected_by_password = `nmcli -t -f WIFI-PROPERTIES dev show wlp0s20f3 | grep .WPA | grep -oP 'yes' | head -1`);
        $is_wifi_protected_by_password = $is_wifi_protected_by_password eq "yes";

        if (time % 3 == 0 || !$has_connection_to_internet) {
            chomp($has_connection_to_internet = `ping -c 1 1.1.1.1` =~ /1 packets transmitted, 1 received/);
        }

        my $wifi_icon_map;
        my $wifi_icon_step = int(($wifi_percentage - ($wifi_percentage % 25)) / 25);

        if ($has_connection_to_internet) {
            if ($is_wifi_protected_by_password) {
                $wifi_icon_map = {
                    4 => "󰤪",
                    3 => "󰤧",
                    2 => "󰤤",
                    1 => "󰤡",
                    0 => "󰤬"
                };
            } else {
                $wifi_icon_map = {
                    4 => "󰤨",
                    3 => "󰤥",
                    2 => "󰤢",
                    1 => "󰤟",
                    0 => "󰤯"
                };
            }
        } else {
            $wifi_icon_map = {
                4 => "󰤩",
                3 => "󰤦",
                2 => "󰤣",
                1 => "󰤠",
                0 => "󰤫"
            };
        }
        my $wifi_icon = $wifi_icon_map->{$wifi_icon_step} || $wifi_icon_map->{0};
        my $wifi_color;

        if ($wifi_percentage > 70) {
            $wifi_color = $Color{Good};
        } elsif ($wifi_percentage > 20) {
            $wifi_color = $Color{Unhealthy};
        } else {
            $wifi_color = $Color{Bad};
        }

        push @blocks, {
            full_text => "$wifi_icon  $wifi_id ($wifi_percentage%)",
            color => $wifi_color,
            name => "wifi"
        };
    }

    # Grab current battery
    my $battery_path = "/sys/class/power_supply/BAT0";
    if (-d $battery_path) {
        chomp(my $battery_charge_full = `cat $battery_path/charge_full`);
        chomp(my $battery_charge_now = `cat $battery_path/charge_now`);
        chomp(my $battery_status = `cat $battery_path/status`);
        my $battery_percentage = ((int($battery_charge_now) / int($battery_charge_full)) * 100);
        my $battery_color;
        $battery_percentage = sprintf("%.2f", $battery_percentage) + 0;
        my $is_charging = ($battery_status eq "Charging" || $battery_status eq "Full") ? 1 : 0;
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
            $battery_color = $Color{Healthy};
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

            if ($battery_percentage < 20) {
                $battery_color = $Color{Bad};
            } elsif ($battery_percentage < 50) {
                $battery_color = $Color{Unhealthy};
            }
        }

        push @blocks, {
            full_text => "$battery_icon $battery_percentage%",
            name => "battery",
            color => $battery_color
        };
    }

    # Grab the current keyboard layout
    my $keyboard_layout = `setxkbmap -query | grep layout`;
    # Chads way of getting the keyboard layout
    $keyboard_layout = substr($keyboard_layout, 12, 2);

    push @blocks, {
        full_text => "󰌓 $keyboard_layout",
        name => "keyboard"
    };

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
    my $volume_color = $volume eq 0 ? $Color{Muted} : $Color{Default};

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
        color => $volume_color,
        name => "volume"
    };

    # Run the brightnessctl command and capture its output
    my $brightness = `brightnessctl`;
    # Match the pattern to extract the percentage
    if ($brightness =~ /Current brightness: \S+ \((\d+)%\)/) {
        # Store the matched percentage in a variable
        my $brightness_percentage = $1;
        my $brightness_icon_map = {
            100 => "󰛨",
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