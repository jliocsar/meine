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

sub meine_i3_prompt {
    my $placeholder = shift;
    my $msg = shift;
    chomp(my $result = `i3-input -F '$msg' -P '$placeholder' `);
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
    my @workspace_names = map { $_->{name} } @current_i3_workspaces;
    my $names = join("|", sort @workspace_names);

    my $workspace_name_result = meine_i3_prompt "Rename workspace <$names>: ", "echo %s";
    $workspace_name_result = `echo "$workspace_name_result" | tail -1`;
    $workspace_name_result =~ s/command = echo //;
    chomp $workspace_name_result;

    print($workspace_name_result);

    my $workplace_to_rename;
    for my $workspace (@current_i3_workspaces) {
        my $workspace_name = $workspace->{name};
        if ($workspace_name =~ "^$workspace_name_result.*") {
            $workplace_to_rename = $workspace_name;
            last;
        }
    }

    if ($workplace_to_rename) {
        chomp $workplace_to_rename;
    } else {
        my $visible_workspace;
        for my $workspace (@current_i3_workspaces) {
            if ($workspace->{visible}) {
                $visible_workspace = $workspace->{name};
                last;
            }
        }
    }

    # Most likely canceled the prompt
    unless ($workplace_to_rename) {
        notify "Workspace rename", "Canceled", {
            urgency => "low",
            time => 3000,
        };
        exit 0;
    }

    chomp(my $workspace_new_name_result = meine_i3_prompt "Enter new name for workspace <$workplace_to_rename>: ", "echo %s");
    chomp($workspace_new_name_result = `echo "$workspace_new_name_result" | tail -1`);
    $workspace_new_name_result =~ s/command = echo //;
    chomp $workspace_new_name_result;

    my $workspace_id = $workplace_to_rename =~ s/:.*//r;
    my $new_workspace = $workspace_id;

    unless ($workspace_new_name_result eq "") {
        $new_workspace = "$new_workspace:$workspace_new_name_result";
    }

    system("i3-msg 'rename workspace \"$workplace_to_rename\" to \"$new_workspace\"'");
    exit 0;
}

meine_i3_prompt_print_help();
exit 1;
