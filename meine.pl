#!/usr/bin/perl
use strict;
use warnings;

my $op_type = $ARGV[0];
sub meine_print_help {
    print "Usage: meine <sync|open|dotfiles>\n";
}

unless (defined $op_type) {
    meine_print_help();
    exit 1;
}

my $HOME = $ENV{HOME};
my $ROOT = "$HOME/.meine";
my $DOTSTORAGE = "$ROOT/dotstorage";

sub meine_sync {
    print "Syncing meine to Git...\n";
    `cd $ROOT && git add . && git commit -m 'sync' && git push`;
    print "All done!\n";
}

sub meine_open {
    print "Opening meine in VS Code...\n";
    `code $ROOT`;
}

if ($op_type eq "sync") {
    meine_sync();
    exit 0;
} 

if ($op_type eq "open") {
    meine_open();
    exit 0;
}

unless ($op_type eq "dotfiles") {
    print "Invalid operation type\n";
    meine_print_help();
    exit 1;
}

sub meine_dotfiles_print_help {
    print "Usage: meine dotfiles <link|unlink|list|edit>\n";
}

my $dotfiles_op_type = $ARGV[1];
unless (defined $dotfiles_op_type) {
    meine_dotfiles_print_help();
    exit 1;
}

sub meine_dotfiles_list {
    my $dotfiles = `find $DOTSTORAGE -type f`;
    my @dotfiles = split("\n", $dotfiles);

    for my $dotfile (@dotfiles) {
        # Replaces `$ROOT/dotstorage/` with nothing
        $dotfile =~ s/^$ROOT\/dotstorage\///;
        print "$dotfile\n";
    }
}

if ($dotfiles_op_type eq "list") {
    meine_dotfiles_list();
    exit 0;
}

sub meine_dotfiles_link {
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
        $dotfile_home_path =~ s/^$ROOT\/dotstorage/$HOME/;
        
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

        if ($response eq "y") {
            `ln -s $dotfile $dotfile_home_path`;
            print "Linked $dotfile to $dotfile_home_path\n";
        }
    }
}

if ($dotfiles_op_type eq "link") {
    meine_dotfiles_link();
    exit 0;
}

sub meine_dotfiles_unlink {
    my $file_to_unlink = $ARGV[2];
    unless (defined $file_to_unlink) {
        print "Usage: meine dotfiles unlink <file>\n";
        exit 1;
    }

    $file_to_unlink =~ s/^$ROOT\/dotstorage/$HOME/;

    if (-e $file_to_unlink and -l $file_to_unlink) {
        print "Unlinking $file_to_unlink\n";
        unlink $file_to_unlink or die "Could not unlink $file_to_unlink: $!";
    } else {
        print "No link at $file_to_unlink\n";
    }
}

if ($dotfiles_op_type eq "unlink") {
    meine_dotfiles_unlink();
    exit 0;
}

sub meine_dotfiles_edit {
    `code $DOTSTORAGE`;
    exit 0;
}

if ($dotfiles_op_type eq "edit") {
    meine_dotfiles_edit();
    exit 0;
}

print "Invalid operation type\n";
meine_dotfiles_print_help();
exit 1;
