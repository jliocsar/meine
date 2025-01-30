#!/usr/bin/perl

use strict;
use warnings;

chomp(my $root = `dirname $0`);
my $home = $ENV{HOME};
my $dotfiles_link_file = "$root/dotfiles";
my $dotstorage = "$root/dotstorage";
my $separator = " > ";

my $op_type = $ARGV[0];
my $rel_dotfile_path = $ARGV[1];

sub meine_dotfiles_sync {
    # Create dotfiles storage if it does not exist
    unless (-e $dotstorage) {
        print "Creating dotfiles storage at $dotstorage\n";
        `mkdir $dotstorage`;
    }

    # Sync dotfiles from dotfiles file
    open(my $fh, "<", $dotfiles_link_file) or die "Could not open file $dotfiles_link_file";
    while (my $line = <$fh>) {
        # Remove newline character
        chomp($line);

        # Split line into linked and dotfile paths
        my ($linked_abs_dotfile_path, $linked_rel_dotfile_path) = split($separator, $line);
        my $target_dir = `dirname $linked_rel_dotfile_path`;
        my $dotfile_path = "$dotstorage/$linked_rel_dotfile_path";

        # Create target directory if it does not exist
        `mkdir -p $dotstorage/$target_dir`;

        # Sync dotfile
        `cp $linked_abs_dotfile_path $dotfile_path`;

        print "Synced $linked_abs_dotfile_path to $dotfile_path\n";
    }

    # Close file handle
    close($fh);
}

sub meine_dotfiles_eternalsync {
    # Just eternally sync by sleeping and recursively calling sync
    meine_dotfiles_sync();
    sleep 300;
    meine_dotfiles_eternalsync();
}

sub meine_dotfiles_add {
    # We use the absolute path to the dotfile
    chomp(my $abs_dotfile_path = `readlink -f $rel_dotfile_path`);

    # Check if dotfile path is valid and in home directory
    unless ($abs_dotfile_path =~ m/^$home/) {
        print "Dotfile $abs_dotfile_path is not in home directory\n";
        exit 1;
    }

    # Check if dotfile exists
    unless (-e $abs_dotfile_path) {
        print "File $abs_dotfile_path does not exist\n";
        exit 1;
    }

    # Get dotfile relative path from the home directory
    my $dotfile_name = $abs_dotfile_path =~ s/(\.|$home)\///r;

    # Create dotfiles storage if it does not exist
    unless (-e $dotfiles_link_file) {
        print "Creating dotfiles storage at $dotfiles_link_file\n";
        `touch $dotfiles_link_file`;
    }

    # Check if dotfile is already added to dotfiles file
    open(my $fh, "<", $dotfiles_link_file) or die "Could not open file $dotfiles_link_file";
    while (my $line = <$fh>) {
        chomp($line);
        my ($linked_abs_dotfile_path) = split($separator, $line);
        if ($linked_abs_dotfile_path eq $abs_dotfile_path) {
            print "Dotfile $dotfile_name already added to $dotfiles_link_file\n";
            exit 0;
        }
    }
    close($fh);

    # Add dotfile to dotfiles file
    `echo '$abs_dotfile_path$separator$dotfile_name' >> $dotfiles_link_file`;

    print "Dotfile $dotfile_name added to $dotfiles_link_file\n";
    print "Resyncing dotfiles...\n";

    meine_dotfiles_sync();
}

sub meine_dotfiles_remove {
    # Check if dotfiles link file exists
    unless (-e $dotfiles_link_file) {
        print "Dotfiles link file does not exist. Add files first.\n";
        exit 1;
    }

    # We use the absolute path to the dotfile
    chomp(my $abs_dotfile_path = `readlink -f $rel_dotfile_path`);

    # Check if dotfile path exists
    unless (-e $abs_dotfile_path) {
        print "File $abs_dotfile_path does not exist\n";
        exit 1;
    }

    # Remove dotfile from dotfiles file
    open(my $read_fh, "<", $dotfiles_link_file)
       or die qq(Can't open file "$dotfiles_link_file" for reading: $!\n);

    my @file_lines = <$read_fh>;
    close($read_fh);

    open(my $write_fh, ">", $dotfiles_link_file)
        or die qq(Can't open file "$dotfiles_link_file" for writing: $!\n);

    foreach my $line (@file_lines) {
        if ($line =~ /$abs_dotfile_path/) {
            my ($linked_abs_dotfile_path, $dotfile_path) = split($separator, $line);
            my $abs_dotfile_path = "$dotstorage/$dotfile_path";
            # Unlink doesn't work for some reason
            `rm $abs_dotfile_path`;
        } else { 
            print {$write_fh} $line;
        }
    }

    # Check for empty directories (recursively) within dotfiles storage and remove them
    `find $dotstorage -type d -empty -delete`;

    # Close file handles
    close($write_fh);

    print "Dotfile $abs_dotfile_path removed from $dotfiles_link_file\n";
}

sub meine_dotfiles_list {
    # Check if dotfiles link file exists
    unless (-e $dotfiles_link_file) {
        print "Dotfiles link file does not exist. Add files first.\n";
        exit 1;
    }

    # List dotfiles from dotfiles file
    open(my $fh, "<", $dotfiles_link_file) or die "Could not open file $dotfiles_link_file";
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

unless ($op_type eq "add" and $rel_dotfile_path) {
    print "Usage: dotfiles.pl <add|remove|list|sync|eternalsync> <dotfile_path>\n";
    exit 1;
}

meine_dotfiles_add()
