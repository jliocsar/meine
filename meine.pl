#!/usr/bin/env perl
use strict;
use warnings;

use constant ROOT => ".meine";

# Check for a command and exit printing help if none is provided
my $op_type = $ARGV[0];
sub meine_print_help {
    print "Usage: meine <sync|open|dotstorage|dotfiles>\n";
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

sub meine_color {
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

		return $formatted;
}

sub meine_print {
	my $msg = shift;
	my $options = shift;
	my $new_line = 1;

	if (defined $options) {
		$new_line = $options->{new_line};
	}

	my $new_line_char = $new_line == 1 && "\n" || "";

	$msg = "$LABEL $msg$new_line_char";
	print $msg;
}

# Define constants
my $HOME = $ENV{HOME};
my $MY_ROOT = "$HOME/".ROOT;
my $DOTSTORAGE = "$MY_ROOT/dotstorage";
my $DOTFILES_CACHE_PATH = "$HOME/.meine-dotfiles";

# Perform sync if requested
if ($op_type eq "sync") {
    meine_print "Syncing meine to Git...";
    `cd $MY_ROOT && git add . && git commit -m 'sync' && git push`;
    meine_print(meine_color("All done!", { fg_color => "green" }));
    exit 0;
}

# Open meine in editor of choice if requested
if ($op_type eq "open") {
		my $EDITOR = $ENV{EDITOR};
    meine_print(meine_color("Opening ~/".ROOT." in $EDITOR...", { fg_color => "cyan" }));
    system("$EDITOR $MY_ROOT") == 0 or die "Failed to open ~/".ROOT." in $EDITOR: $!";
    exit 0;
}

# Check for a dotfiles operation and exit printing help if none is provided
sub meine_dotstorage_print_help {
    print "Usage: meine dotstorage <list|edit>\n";
}

if ($op_type eq "dotstorage") {
		my $dotstorage_op_type = $ARGV[1];
		unless (defined $dotstorage_op_type) {
			meine_print(meine_color("Invalid operation type", { fg_color => "red" }));
			meine_dotstorage_print_help();
			exit 1;
		}

		if ($dotstorage_op_type eq "edit") {
				my $EDITOR = $ENV{EDITOR};
				meine_print(meine_color("Opening $DOTSTORAGE in $EDITOR...", { fg_color => "cyan" }));
				system("$EDITOR $DOTSTORAGE") == 0 or die "Failed to open $DOTSTORAGE in $EDITOR: $!";
				exit 0;
		}

		if ($dotstorage_op_type eq "list") {
				my @tree_command_args = @ARGV[2..$#ARGV];
				my $tree_command_args = join(" ", @tree_command_args);
				system("tree -a $tree_command_args $DOTSTORAGE") == 0 or die "Failed to list dotstorage files";
				exit 0;
		}

    meine_print(meine_color("Invalid operation type", { fg_color => "red" }));
    meine_dotstorage_print_help();
    exit 1;
}

# From here on only dotfiles operations are allowed
# Exit if invalid operation type is provided
unless ($op_type eq "dotfiles") {
    meine_print(meine_color("Invalid operation type", { fg_color => "red" }));
    meine_print_help();
    exit 1;
}

# Check for a dotfiles operation and exit printing help if none is provided
sub meine_dotfiles_print_help {
    print "Usage: meine dotfiles <link|unlink|list|edit>\n";
}

# Check for a valid `meine dotfiles` command
my $dotfiles_op_type = $ARGV[1];
unless (defined $dotfiles_op_type) {
    meine_dotfiles_print_help();
    exit 1;
}

sub get_dotfiles_list {
		my @dotfiles = ();
		open(my $cache_fh, '<', $DOTFILES_CACHE_PATH);
		
		while (my $line = <$cache_fh>) {
			next if $line =~ /^(#.*|\s+|\n)$/;
			chomp $line;
			push @dotfiles, $line;
		}

		close $cache_fh;
		return @dotfiles;
}

# List all dotfiles in dotstorage if requested
if ($dotfiles_op_type eq "list") {
		meine_print("Dotfiles", { new_line => 0 });

		my @dotfiles_list = get_dotfiles_list();
		my $dotfiles = "";

		for my $dotfile (@dotfiles_list) {
			my $last_char = substr($dotfile, -1, 1);
			my $icon = $last_char eq "/" && "􀈕 " || "􀈷 ";
			$dotfiles = "$dotfiles\n$icon $dotfile";
		}

		print $dotfiles;

    # Exit after listing all dotfiles
    exit 0;
}

# Link dotfiles in dotstorage to $HOME if requested
if ($dotfiles_op_type eq "link") {
		unless (-e $DOTFILES_CACHE_PATH) {
			meine_print 'Create a dotfiles path in ' . meine_color($DOTFILES_CACHE_PATH, { fg_color => "blue" }) . ' first.'; 
			exit 1;
		}

		for my $dotfile (get_dotfiles_list()) {
			my $dotfile_dotstorage_path = "$DOTSTORAGE/$dotfile";

			unless (-e $dotfile_dotstorage_path) {
				meine_print "File " . meine_color($dotfile, { fg_color => "red" }) . " was not found in dotstorage";
				next;
			}

			# Check if the dotfile ends with "/" in case it's a directory
			if (-d $dotfile_dotstorage_path && !(substr($dotfile, -1, 1) eq "/")) {
				meine_print "The path " . meine_color($dotfile, { fg_color => "blue" }) . " is a directory, but not used as such in the dotfile text. Append " . meine_color('/', { bold => 1 }) . " to its end to fix this.";
				next;
			}

			my $dotfile_home_path = "$HOME/$dotfile";

			if (-l $dotfile_home_path) {
				meine_print 'Dotfile link for ' . meine_color($dotfile, { fg_color => "blue" }) . ' already exists in home directory.';
				next;
			}

			# TODO: Is this even right?
			if (!-l $dotfile_home_path && -d $dotfile_home_path) {
				meine_print 'Dotfile link for ' . meine_color($dotfile, { fg_color => "blue" }) . ' already exists in home directory.';
				next;
			}

			if (-e $dotfile_home_path) {
				meine_print 'A file already exists in home directory: ' . meine_color($dotfile, { fg_color => "blue" });
				next;
			}

			system("ln -s $dotfile_dotstorage_path $dotfile_home_path") == 0 or die "Failed on linking dotfile";

			meine_print "Created link for " . meine_color($dotfile, { fg_color => "green" }) . " successfully";
		}

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

		chomp $file_to_unlink;
		$file_to_unlink = "$HOME/$file_to_unlink";

		unless (-l $file_to_unlink) {
			$file_to_unlink = meine_color($file_to_unlink);
			meine_print 'No file to unlink at ' . meine_color($file_to_unlink, { fg_color => "red" });
			exit 1;
		}

    # Unlink the provided file if it exists and is a link
		meine_print "Unlinking " . meine_color($file_to_unlink, { fg_color => "yellow" });
		unlink $file_to_unlink or die "Could not unlink $file_to_unlink: $!";

		# Clear cache file after unlinking
		open (my $read_cache_fh, '<', $DOTFILES_CACHE_PATH);
		my @new_lines = ();
	
		while (my $line = <$read_cache_fh>) {
			chomp $line;
			my $line_home_path = "$HOME/$line";
			next if $line_home_path eq $file_to_unlink;
			push @new_lines, $line;
		}

		close $read_cache_fh;
		my $new_lines = join("\n", @new_lines);

		open (my $write_cache_fh, '>', $DOTFILES_CACHE_PATH);
		print $write_cache_fh $new_lines;
		close $write_cache_fh;

    # Exit after unlinking the provided file
    exit 0;
}

# Edit dotfiles in dotstorage with editor of choice if requested
if ($dotfiles_op_type eq "edit") {
		my $EDITOR = $ENV{EDITOR};
		meine_print(meine_color("Editing dotfiles in $EDITOR", { fg_color => "cyan" }));
    system("$EDITOR $DOTFILES_CACHE_PATH") == 0 or die "Failed to open $DOTFILES_CACHE_PATH in $EDITOR: $!";
    exit 0;
}

meine_print "Invalid operation type";
meine_dotfiles_print_help();
exit 1;
