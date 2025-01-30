#!/usr/bin/perl
use strict;
use warnings;

my $SEPARATOR = " > ";
my $HOME = $ENV{HOME};

chomp(my $root = `dirname $0`);
my $meine_dotfile_buffer = "$root/dotfiles";
my $dotstorage = "$root/dotstorage";

my $op_type = $ARGV[0];
my $arg_dotfile_path = $ARGV[1];

sub meine_dotfiles_sync {
    # Create dotfiles storage if it does not exist
    unless (-e $dotstorage) {
        print "Creating dotfiles storage at $dotstorage\n";
        `mkdir $dotstorage`;
    }

    # Sync dotfiles from dotfiles file
    open(my $fh, "<", $meine_dotfile_buffer) or die "Could not open file $meine_dotfile_buffer";
    while (my $line = <$fh>) {
        # Remove newline character
        chomp($line);

        # Split line into linked and dotfile paths
        my ($meine_stored_abs_dotfile_path, $meine_stored_internal_rel_dotfile_path) = split($SEPARATOR, $line);
        my $meine_stored_internal_dotfile_dir = `dirname $meine_stored_internal_rel_dotfile_path`;
        my $meine_dotstorage_dotfile_path = "$dotstorage/$meine_stored_internal_rel_dotfile_path";

        # Create target directory if it does not exist
        `mkdir -p $dotstorage/$meine_stored_internal_dotfile_dir`;

        # Sync dotfile
        `cp $meine_stored_abs_dotfile_path $meine_dotstorage_dotfile_path`;

        print "Synced $meine_stored_abs_dotfile_path to $meine_dotstorage_dotfile_path\n";
    }

    # Close file handle
    close($fh);
}

sub meine_dotfiles_eternalsync {
    # Just eternally sync by sleeping and recursively calling sync
    meine_dotfiles_sync();
    sleep 300;
    return meine_dotfiles_eternalsync();
}

sub meine_dotfiles_add {
    # We use the absolute path to the dotfile
    chomp(my $abs_arg_dotfile_path = `readlink -f $arg_dotfile_path`);

    # Check if dotfile path is valid and in home directory
    unless ($abs_arg_dotfile_path =~ m/^$HOME/) {
        print "Dotfile $abs_arg_dotfile_path is not in home directory\n";
        exit 1;
    }

    # Check if dotfile exists
    unless (-e $abs_arg_dotfile_path) {
        print "File $abs_arg_dotfile_path does not exist\n";
        exit 1;
    }

    # Get dotfile relative path from the home directory
    my $arg_dotfile_name = $abs_arg_dotfile_path =~ s/(\.|$HOME)\///r;

    # Create dotfiles storage if it does not exist
    unless (-e $meine_dotfile_buffer) {
        print "Creating dotfiles storage at $meine_dotfile_buffer\n";
        `touch $meine_dotfile_buffer`;
    }

    # Check if dotfile is already added to dotfiles file
    open(my $fh, "<", $meine_dotfile_buffer) or die "Could not open file $meine_dotfile_buffer";
    while (my $line = <$fh>) {
        chomp($line);
        my ($meine_stored_abs_dotfile_path) = split($SEPARATOR, $line);
        if ($meine_stored_abs_dotfile_path eq $abs_arg_dotfile_path) {
            print "Dotfile $arg_dotfile_name already added to $meine_dotfile_buffer\n";
            exit 0;
        }
    }
    close($fh);

    # Add dotfile to dotfiles file
    `echo '$abs_arg_dotfile_path$SEPARATOR$arg_dotfile_name' >> $meine_dotfile_buffer`;

    print "Dotfile $arg_dotfile_name added to $meine_dotfile_buffer\n";
    print "Resyncing dotfiles...\n";

    meine_dotfiles_sync();
}

sub meine_dotfiles_remove {
    # Check if dotfiles link file exists
    unless (-e $meine_dotfile_buffer) {
        print "Dotfiles link file does not exist. Add files first.\n";
        exit 1;
    }

    # We use the absolute path to the dotfile
    chomp(my $abs_arg_dotfile_path = `readlink -f $arg_dotfile_path`);

    # Check if dotfile path exists
    unless (-e $abs_arg_dotfile_path) {
        print "File $abs_arg_dotfile_path does not exist\n";
        exit 1;
    }

    # Remove dotfile from dotfiles file
    open(my $read_fh, "<", $meine_dotfile_buffer)
       or die qq(Can't open file "$meine_dotfile_buffer" for reading: $!\n);

    my @file_lines = <$read_fh>;
    close($read_fh);

    open(my $write_fh, ">", $meine_dotfile_buffer)
        or die qq(Can't open file "$meine_dotfile_buffer" for writing: $!\n);

    foreach my $line (@file_lines) {
        if ($line =~ /$abs_arg_dotfile_path/) {
            my ($meine_stored_abs_dotfile_path, $dotfile_path) = split($SEPARATOR, $line);
            my $meine_dotstorage_dotfile_path = "$dotstorage/$dotfile_path";
            # Unlink doesn't work for some reason
            `rm $meine_dotstorage_dotfile_path`;
        } else { 
            print {$write_fh} $line;
        }
    }

    # Check for empty directories (recursively) within dotfiles storage and remove them
    `find $dotstorage -type d -empty -delete`;

    # Close file handles
    close($write_fh);

    print "Dotfile $abs_arg_dotfile_path removed from $meine_dotfile_buffer\n";
}

sub meine_dotfiles_list {
    # Check if dotfiles link file exists
    unless (-e $meine_dotfile_buffer) {
        print "Dotfiles link file does not exist. Add files first.\n";
        exit 1;
    }

    # List dotfiles from dotfiles file
    open(my $fh, "<", $meine_dotfile_buffer) or die "Could not open file $meine_dotfile_buffer";
    while (my $line = <$fh>) {
        print $line;
    }

    # Close file handle
    close($fh);
}

if ($op_type eq "eternalsync") {
    meine_dotfiles_eternalsync();
    exit 0;
}

if ($op_type eq "sync") {
    meine_dotfiles_sync();
    exit 0;
}

if ($op_type eq "list") {
    meine_dotfiles_list();
    exit 0;
}

if ($op_type eq "update") {
    meine_dotfiles_sync();
    exit 0;
}

if ($op_type eq "remove") {
    meine_dotfiles_remove();
    exit 0;
}

unless ($op_type eq "add" and $arg_dotfile_path) {
    print "Usage: dotfiles.pl <add|remove|list|sync|eternalsync> <dotfile_path>\n";
    exit 1;
}

meine_dotfiles_add()
