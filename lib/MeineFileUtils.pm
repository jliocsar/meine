package Meine::File::Utils;

sub replace_in_file {
    my $file = shift;
    my $search = shift;
    my $replace = shift;

    open my $fh, "<", $file or die "Failed to open file: $!";
    for my $line (<$fh>) {
        if ($line =~ /$search/) {
            $line = $replace;
        }
        print $fh $line;
    }
    close $fh;

    return 1;
}

1;
