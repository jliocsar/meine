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
    my $last_block = pop @blocks;
    @blocks = (@blocks, {
        full_text => "$keyboard_layout",
        name => "keyboard"
    }, $last_block);

    # Run the brightnessctl command and capture its output
    my $brightness = `brightnessctl`;

    # Match the pattern to extract the percentage
    if ($brightness =~ /Current brightness: \S+ \((\d+)%\)/) {
        # Store the matched percentage in a variable
        my $brightness_percentage = $1;

        # Prefix our own information (you could also suffix or insert in the middle).
        @blocks = ({
            full_text => "brightness $brightness_percentage%",
            name => "brightness"
        }, @blocks);
    }

    @blocks = ({
        full_text => "need coffee",
        name => "node"
    }, @blocks);

    # Output the line as JSON.
    print encode_json(\@blocks) . ",\n";
}