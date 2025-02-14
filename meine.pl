#!/usr/bin/env perl
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

# Utils functions
my %FgAnsiColor = (
    red => "\e[31m",
    green => "\e[32m",
    yellow => "\e[33m",
    blue => "\e[34m",
    magenta => "\e[35m",
    cyan => "\e[36m",
    white => "\e[37m",
    reset => "\e[0m",
);
my %BgAnsiColor = (
    red => "\e[41m",
    green => "\e[42m",
    yellow => "\e[43m",
    blue => "\e[44m",
    magenta => "\e[45m",
    cyan => "\e[46m",
    white => "\e[47m",
    reset => "\e[0m",
);
my $Bold = "\e[1m";
my $Dim = "\e[2m";

my $LABEL = $Dim . $Bold . "[🐗 meine]" . $FgAnsiColor{reset};

sub meine_print {
    my $msg = shift;
    my $options = shift;
    my $fg_color = $options->{fg_color};
    my $bg_color = $options->{bg_color};
    my $bold = $options->{bold};
    my $formatted = $msg;

    if (defined $fg_color) {
        $formatted = $FgAnsiColor{$fg_color} . $formatted . $FgAnsiColor{reset};
    }

    if (defined $bg_color) {
        $formatted = $BgAnsiColor{$bg_color} . $formatted . $BgAnsiColor{reset};
    }

    if ($bold) {
        $formatted = "\e[1m" . $formatted . "\e[0m";
    }   

    print $LABEL . " " . $formatted . "\n";
}

# Define constants
my $HOME = $ENV{HOME};
my $MY_ROOT = "$HOME/".ROOT;
my $DOTSTORAGE = "$MY_ROOT/dotstorage";

# Perform sync if requested
if ($op_type eq "sync") {
    meine_print "Syncing meine to Git...";
    `cd $MY_ROOT && git add . && git commit -m 'sync' && git push`;
    meine_print "All done!", { fg_color => "green" };
    exit 0;
}

# Open meine in VS Code if requested
if ($op_type eq "open") {
    meine_print "Opening ~/".ROOT." in VS Code...", { fg_color => "green" };
    system("swallow code -w $MY_ROOT") == 0 or die "Failed to open ~/".ROOT." in VS Code: $!";
    exit 0;
}

# From here on only dotfiles operations are allowed
# Exit if invalid operation type is provided
unless ($op_type eq "dotfiles") {
    meine_print "Invalid operation type", { fg_color => "red" };
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
    my @dotdirs = split("\n", `find $DOTSTORAGE -type d`);

    if (scalar @dotfiles == 0 || scalar @dotdirs == 0) {
        meine_print "No dotfiles in dotstorage", { fg_color => "yellow" };
        exit 0;
    }

    sub print_title {
        my $title = shift;
        print($Bold . $FgAnsiColor{white} . $title . $FgAnsiColor{reset} . "\n");
    }

    meine_print "🔒 Dotstorage:\n", { fg_color => "green" };

    print_title "📜 Directories:";
    for my $dotdir (@dotdirs) {
        # Replaces `$MY_ROOT/dotstorage/` with nothing
        $dotdir =~ s/^$MY_ROOT\/dotstorage\///;
        # Check if the dotdir is a symlink under $HOME
        if (-l "$HOME/$dotdir") {
            print "$dotdir\n";
        }
    }

    print "\n";
    print_title "📜 Files:";
    for my $dotfile (@dotfiles) {
        # Replaces `$MY_ROOT/dotstorage/` with nothing
        $dotfile =~ s/^$MY_ROOT\/dotstorage\///;
        # Check if the dotfile is a symlink under $HOME
        if (-l "$HOME/$dotfile") {
            print "$dotfile\n";
        }
    }

    # Exit after listing all dotfiles
    exit 0;
}

# Link dotfiles in dotstorage to $HOME if requested
if ($dotfiles_op_type eq "link") {
    # Create dotfiles storage if it does not exist
    unless (-e $DOTSTORAGE) {
        meine_print "Creating dotfiles storage at $DOTSTORAGE";
        return `mkdir $DOTSTORAGE`;
    }

    # Check if specific link path was provided
    my $link_path = $ARGV[2];
    if (defined $link_path) {
        # Check if it exists inside dotstorage
        my $dotfile = "$DOTSTORAGE/$link_path";

        unless (-e $dotfile) {
            meine_print "No file or directory at $dotfile", { fg_color => "red" };
            exit 1;
        }

        # Link the directory/file to $HOME
        my $dotfile_home_path = "$HOME/$link_path";
        if (-e $dotfile_home_path) {
            if (-l $dotfile_home_path) {
                meine_print "Link already exists at $dotfile_home_path", { fg_color => "cyan" };
                exit 0;
            } else {
                meine_print "File already exists at $dotfile_home_path", { fg_color => "cyan" };
                exit 1;
            }
        } else {
            # Prompts user to confirm linking
            meine_print "Link $dotfile to $dotfile_home_path? [y/n]";

            my $response = <STDIN>;
            while ($response !~ m/^[yYnN]$/) {
                meine_print "Invalid response. Please enter 'y' or 'n'", { fg_color => "red" };
                $response = <STDIN>;
            }
            chomp $response;
            $response = lc $response;

            if ($response eq "y") {
                `ln -s $dotfile $dotfile_home_path`;
                meine_print "Linked $dotfile to $dotfile_home_path", { fg_color => "green" };
            }
        }

        exit 0;
    }

    # Create links for dotfiles in dotstorage
    my $dotfiles = `find $DOTSTORAGE -type f`;
    my @dotfiles = split("\n", $dotfiles);
    my @dotdirs = split("\n", `find $DOTSTORAGE -type d`);
    my %dotdirs_map = map { $_ => 1 } @dotdirs;

    for my $dotfile (@dotfiles) {
        # Replaces the `./dotstorage/` with `$HOME/`
        my $dotfile_home_path = $dotfile;
        $dotfile_home_path =~ s/^$MY_ROOT\/dotstorage/$HOME/;
        
        # Check if link already exists and that it's actually a link
        if (-e $dotfile_home_path) {
            if (-l $dotfile_home_path) {
                meine_print "Link already exists at $dotfile_home_path", { fg_color => "cyan" };
                next;
            } else {
                meine_print "File already exists at $dotfile_home_path", { fg_color => "cyan" };
                next;
            }
        }

        # Prompts user to confirm linking
        meine_print "Link $dotfile to $dotfile_home_path? [y/n]";

        my $response = <STDIN>;
        while ($response !~ m/^[yYnN]$/) {
            meine_print "Invalid response. Please enter 'y' or 'n'", { fg_color => "red" };
            $response = <STDIN>;
        }
        chomp $response;
        $response = lc $response;

        # Link the dotfile if user confirms
        if ($response eq "y") {
            chomp(my $dotfile_home_dir = `dirname $dotfile_home_path`);
            unless (-e $dotfile_home_dir) {
                meine_print "Creating directory $dotfile_home_dir";
                `mkdir -p $dotfile_home_dir`;
            }
            `ln -s $dotfile $dotfile_home_path`;
            meine_print "Linked $dotfile to $dotfile_home_path", { fg_color => "green" };
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
        meine_print "Unlinking $file_to_unlink";
        unlink $file_to_unlink or die "Could not unlink $file_to_unlink: $!";
    } else {
        meine_print "No link at $file_to_unlink", { fg_color => "yellow" };
    }

    # Exit after unlinking the provided file
    exit 0;
}

# Edit dotfiles in dotstorage with VS Code if requested
if ($dotfiles_op_type eq "edit") {
    system("swallow code -w $DOTSTORAGE") == 0 or die "Failed to open $DOTSTORAGE in VS Code: $!";
    exit 0;
}

meine_print "Invalid operation type";
meine_dotfiles_print_help();
exit 1;
