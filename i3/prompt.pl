#!/usr/bin/env perl
use strict;
use warnings;
use JSON;

sub meine_i3_prompt_print_help {
    print "Usage: prompt.pl <rename-ws>\n";
}

my $opt_type = $ARGV[0];

unless (defined $opt_type) {
    meine_i3_prompt_print_help();
    exit 1;
}

my $MEINE_DMENU_THEME = "Meine-Pop-Dark";

sub meine_i3_prompt {
    my $placeholder = shift;
    chomp(my $result = `rofi -dmenu -theme $MEINE_DMENU_THEME -theme-str 'listview { lines: 0; border: 1px; padding: 0; } entry { placeholder: ""; }' -p '$placeholder'`);
    return $result;
}

sub notify {
    my $title = shift;
    my $msg = shift;
    my $options = shift;
    my $time = $options->{'time'} || 1500;
    my $urgency = $options->{'urgency'} || "normal";
    my $icon = $options->{'icon'} || "dialog-information";
    system("notify-send --icon='$icon' --urgency='$urgency' --expire-time=$time '$title' '$msg'");
}

if ($opt_type eq "rename-ws") {
    chomp(my $current_i3_workspaces = `i3-msg -t get_workspaces`);
    my @current_i3_workspaces = @{decode_json($current_i3_workspaces)};
    my @workspace_names = map { "$_->{name}" } @current_i3_workspaces;
    my $names = join(", ", sort @workspace_names);

    my $workspace_name_result = meine_i3_prompt "Rename workspace ($names or \@me)";
    if ($workspace_name_result eq "") {
        notify "Workspace rename", "Canceled", {
            urgency => "low",
            time => 3000,
        };
        exit 0;
    }

    my $workspace_to_rename = $workspace_name_result;
    if ($workspace_to_rename eq "\@me") {
        my $visible_workspace;
        for my $workspace (@current_i3_workspaces) {
            if ($workspace->{visible}) {
                $visible_workspace = $workspace->{name};
                last;
            }
        }
        $workspace_to_rename = $visible_workspace;
    } else {
        for my $workspace (@current_i3_workspaces) {
            my $workspace_name = $workspace->{name};
            if ($workspace_name =~ "^$workspace_name_result.*") {
                $workspace_to_rename = $workspace_name;
                last;
            }
        }
    }

    if ($workspace_to_rename) {
        chomp $workspace_to_rename;
    } else {
        notify "Workspace rename", "Workspace not found", {
            urgency => "low",
            time => 3000,
        };
        exit 0;
    }

    chomp(my $workspace_new_name_result = meine_i3_prompt "Enter new name for workspace ($workspace_to_rename or :reset)");
    if ($workspace_new_name_result eq "") {
        notify "Workspace rename", "Canceled", {
            urgency => "low",
            time => 3000,
        };
        exit 0;
    }

    if ($workspace_new_name_result eq ":reset") {
        $workspace_new_name_result = "";
    }

    my $workspace_id = $workspace_to_rename =~ s/:.*//r;
    my $new_workspace = $workspace_id;

    unless ($workspace_new_name_result eq "") {
        $new_workspace = "$new_workspace:$workspace_new_name_result";
    }

    system("i3-msg 'rename workspace \"$workspace_to_rename\" to \"$new_workspace\"'");
    exit 0;
}

meine_i3_prompt_print_help();
exit 1;
