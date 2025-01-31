#!/usr/bin/perl
use strict;
use warnings;

use constant ROOT => ".meine";

# Check for a command and exit printing help if none is provided
my $op_type = $ARGV[0];
sub meine_print_help {
    print "Usage: meine <sync|open|dotfiles>\n";
}

unless (defined $op_type) {
    meine_print_help();
    exit 1;
}

# Define constants
my $HOME = $ENV{HOME};
my $MY_ROOT = "$HOME/".ROOT;
my $DOTSTORAGE = "$MY_ROOT/dotstorage";

# Perform sync if requested
if ($op_type eq "sync") {
    print "Syncing meine to Git...\n";
    `cd $MY_ROOT && git add . && git commit -m 'sync' && git push`;
    print "All done!\n";
    exit 0;
}

# Open meine in VS Code if requested
if ($op_type eq "open") {
    print "Opening ~/".ROOT." in VS Code...\n";
    `swallow code $MY_ROOT`;
    exit 0;
}

# From here on only dotfiles operations are allowed
# Exit if invalid operation type is provided
unless ($op_type eq "dotfiles") {
    print "Invalid operation type\n";
    meine_print_help();
    exit 1;
}

# Check for a dotfiles operation and exit printing help if none is provided
sub meine_dotfiles_print_help {
    print "Usage: meine dotfiles <link|unlink|list|edit>\n";
}

my $dotfiles_op_type = $ARGV[1];
unless (defined $dotfiles_op_type) {
    meine_dotfiles_print_help();
    exit 1;
}

# List all dotfiles in dotstorage if requested
if ($dotfiles_op_type eq "list") {
    my $dotfiles = `find $DOTSTORAGE -type f`;
    my @dotfiles = split("\n", $dotfiles);

    for my $dotfile (@dotfiles) {
        # Replaces `$MY_ROOT/dotstorage/` with nothing
        $dotfile =~ s/^$MY_ROOT\/dotstorage\///;
        print "$dotfile\n";
    }

    # Exit after listing all dotfiles
    exit 0;
}

# Link dotfiles in dotstorage to $HOME if requested
if ($dotfiles_op_type eq "link") {
    # Create dotfiles storage if it does not exist
    unless (-e $DOTSTORAGE) {
        print "Creating dotfiles storage at $DOTSTORAGE\n";
        return `mkdir $DOTSTORAGE`;
    }

    # Create links for dotfiles in dotstorage
    my $dotfiles = `find $DOTSTORAGE -type f`;
    my @dotfiles = split("\n", $dotfiles);

    for my $dotfile (@dotfiles) {
        # Replaces the `./dotstorage/` with `$HOME/`
        my $dotfile_home_path = $dotfile;
        $dotfile_home_path =~ s/^$MY_ROOT\/dotstorage/$HOME/;
        
        # Check if link already exists and that it's actually a link
        if (-e $dotfile_home_path) {
            if (-l $dotfile_home_path) {
                print "Link already exists at $dotfile_home_path\n";
                next;
            } else {
                print "File already exists at $dotfile_home_path\n";
                next;
            }
        }

        # Prompts user to confirm linking
        print "Link $dotfile to $dotfile_home_path? [y/n] ";

        my $response = <STDIN>;
        while ($response !~ m/^[yYnN]$/) {
            print "Invalid response. Please enter 'y' or 'n': ";
            $response = <STDIN>;
        }
        chomp $response;

        # Link the dotfile if user confirms
        if ($response eq "y") {
            `ln -s $dotfile $dotfile_home_path`;
            print "Linked $dotfile to $dotfile_home_path\n";
        }
    }

    # Exit after linking all dotfiles
    exit 0;
}

# Unlink a dotfile if requested
if ($dotfiles_op_type eq "unlink") {
    # Check if a file to unlink is provided and exit if not
    my $file_to_unlink = $ARGV[2];
    unless (defined $file_to_unlink) {
        print "Usage: meine dotfiles unlink <file>\n";
        exit 1;
    }

    # Replace `$MY_ROOT/dotstorage` with `$HOME` in the provided file path
    $file_to_unlink =~ s/^$MY_ROOT\/dotstorage/$HOME/;

    # Unlink the provided file if it exists and is a link
    if (-e $file_to_unlink and -l $file_to_unlink) {
        print "Unlinking $file_to_unlink\n";
        unlink $file_to_unlink or die "Could not unlink $file_to_unlink: $!";
    } else {
        print "No link at $file_to_unlink\n";
    }

    # Exit after unlinking the provided file
    exit 0;
}

# Edit dotfiles in dotstorage with VS Code if requested
if ($dotfiles_op_type eq "edit") {
    `swallow code $DOTSTORAGE`;
    exit 0;
}

print "Invalid operation type\n";
meine_dotfiles_print_help();
exit 1;
