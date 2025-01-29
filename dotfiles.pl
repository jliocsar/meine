#!/bin/perl

use strict;
use warnings;

chomp(my $root = `dirname $0`);
my $dotfiles_link_file = "$root/dotfiles";
my $dotfiles_sync_dir = "$root/dotstorage";
my $separator = " > ";

my $op_type = $ARGV[0];
my $rel_dotfile_path = $ARGV[1];

sub meine_dotfiles_sync {
    unless (-e $dotfiles_sync_dir) {
        print "Creating dotfiles storage at $dotfiles_sync_dir\n";
        `mkdir $dotfiles_sync_dir`;
    }

    open(my $fh, "<", $dotfiles_link_file) or die "Could not open file $dotfiles_link_file";
    while (my $line = <$fh>) {
        chomp($line);
        my ($abs_dotfile_path, $dotfile_path) = split($separator, $line);
        my $target_dir = `dirname $dotfile_path`;
        `mkdir -p $target_dir`;
        `cp $abs_dotfile_path $dotfile_path`;
        print "Synced $abs_dotfile_path to $dotfile_path\n";
    }
    close($fh);
}

sub meine_dotfiles_eternalsync {
    meine_dotfiles_sync();
    sleep 300;
    meine_dotfiles_eternalsync();
}

sub meine_dotfiles_add_and_sync {
    chomp(my $current_dir = `pwd`);
    my $abs_dotfile_path = "$current_dir/$rel_dotfile_path";
    my $home = $ENV{"HOME"};

    unless ($abs_dotfile_path =~ m/^$home/) {
        print "Dotfile $abs_dotfile_path is not in home directory\n";
        exit 1;
    }

    unless (-e $abs_dotfile_path) {
        print "File $abs_dotfile_path does not exist\n";
        exit 1;
    }

    my $dotfile_name = $abs_dotfile_path =~ s/(\.|$home)\///r;

    unless (-e $dotfiles_link_file) {
        print "Creating dotfiles storage at $dotfiles_link_file\n";
        `touch $dotfiles_link_file`;
    }

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

    my $dotfile_path = "$dotfiles_sync_dir/$dotfile_name";
    `echo '$abs_dotfile_path$separator$dotfile_path' >> $dotfiles_link_file`;

    print "Dotfile $dotfile_name added to $dotfiles_link_file\n";
    print "Resyncing dotfiles\n";

    meine_dotfiles_sync();
}

sub meine_dotfiles_remove {
    unless (-e $dotfiles_link_file) {
        print "Dotfiles link file does not exist. Add files first.\n";
        exit 1;
    }

    chomp(my $current_dir = `pwd`);
    my $abs_dotfile_path = "$current_dir/$rel_dotfile_path";

    unless (-e $abs_dotfile_path) {
        print "File $abs_dotfile_path does not exist\n";
        exit 1;
    }

    chomp(my $dotfile_name = `basename $abs_dotfile_path`);
    my $dotfile_path = "$dotfiles_sync_dir/$dotfile_name";

    unless (-e $dotfile_path) {
        print "Dotfile $dotfile_name was not synced previously\n";
        exit 1;
    }

    open(my $read_fh, "<", $dotfiles_link_file)
       or die qq(Can't open file "$dotfiles_link_file" for reading: $!\n); 

    my @file_lines = <$read_fh>; 
    close($read_fh); 

    open(my $write_fh, ">", $dotfiles_link_file)
        or die qq(Can't open file "$dotfiles_link_file" for writing: $!\n);

    foreach my $line (@file_lines) { 
        print {$write_fh} $line unless ($line =~ /$abs_dotfile_path/); 
    } 
    close($write_fh); 
    unlink $dotfile_path;

    print "Dotfile $abs_dotfile_path removed from $dotfiles_link_file\n";
}

if ($op_type eq "eternalsync") {
    meine_dotfiles_eternalsync();
    exit 0;
}

if ($op_type eq "sync") {
    meine_dotfiles_sync();
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
    print "Usage: dotfiles.pl <add|remove|sync|eternalsync> <dotfile_path>\n";
    exit 1;
}

meine_dotfiles_add_and_sync()
