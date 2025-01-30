#!/usr/bin/perl
use strict;
use warnings;

my $op_type = $ARGV[0];
unless (defined $op_type) {
    print "Usage: dotfiles_v2.pl <link|unlink|list|edit>\n";
    exit 1;
}

my $HOME = $ENV{HOME};
my $ROOT = "$HOME/.meine";

unless (-e $ROOT) {
    print "Root directory $ROOT does not exist\n";
    exit 1;
}

my $dotstorage = "$ROOT/dotstorage";

sub meine_dotfiles_link {
    # Create dotfiles storage if it does not exist
    unless (-e $dotstorage) {
        print "Creating dotfiles storage at $dotstorage\n";
        return `mkdir $dotstorage`;
    }

    # Create links for dotfiles in dotstorage
    my $dotfiles = `find $dotstorage -type f`;
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

sub meine_dotfiles_unlink {
    my $file_to_unlink = $ARGV[1];
    unless (defined $file_to_unlink) {
        print "Usage: dotfiles_v2.pl unlink <file>\n";
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

sub meine_dotfiles_list {
    my $dotfiles = `find $dotstorage -type f`;
    print $dotfiles;
}

sub meine_dotfiles_edit {
    `code $dotstorage`;
    exit 0;
}

if ($op_type eq "link") {
    meine_dotfiles_link();
} elsif ($op_type eq "list") {
    meine_dotfiles_list();
} elsif ($op_type eq "unlink") {
    meine_dotfiles_unlink();
} elsif ($op_type eq "edit") {
    meine_dotfiles_edit();
} else {
    print "Invalid operation type\n";
    exit 1;
}
