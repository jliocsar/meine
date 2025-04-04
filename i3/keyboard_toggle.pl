#!/usr/bin/env perl
use strict;
use warnings;

my $layout_query = `setxkbmap -query`;

if ($layout_query =~ /layout:\s+(.*)/) {
	my $layout = $1;
	my $toggled_layout = $layout eq "us" && "br" || "us";
	my $notification_msg = "Changed to <b>$toggled_layout</b>";

	`setxkbmap $toggled_layout`;
	`notify-send "Keyboard Layout Change" "$notification_msg" --urgency low --expire-time 2400`;
}

