package App::Nopaste::Service::ssh;
use strict;
use warnings;
use base 'App::Nopaste::Service';
use File::Temp;
use File::Spec;
use POSIX qw(strftime);
use URI::Escape qw(uri_escape);

sub run {
    my ($self, %args) = @_;

    my $source = $args{'filename'};

    my $server  = $ENV{NOPASTE_SSH_SERVER}  || return (0,"No NOPASTE_SSH_SERVER set");
    my $docroot = $ENV{NOPASTE_SSH_DOCROOT} || return (0, "No NOPASTE_SSH_DOCROOT set");
    my $topurl  = $ENV{NOPASTE_SSH_WEBPATH} || "http://$server";
    my $mode    = $ENV{NOPASTE_SSH_MODE}    || undef;
    my $usedesc = defined $ENV{NOPASTE_SSH_USE_DESCRIPTION}
                    ? $ENV{NOPASTE_SSH_USE_DESCRIPTION}
                    : 1;

    my $date = strftime("%Y-%m-%d",localtime());
    my ($ext) = defined $source && $source =~ s/(\.[^.]+?)$// ? $1 : '';

    my $suffix = $ext;
    if ($usedesc) {
        if (not $args{'desc'}) {
            my ($vol, $dirs, $file) = File::Spec->splitpath($source);
            $args{'desc'} = $file || '';
        }
        $args{'desc'} =~ s/\s+/+/g; # more readable than %20
        $suffix = ($args{'desc'} ? '-' : '') . $args{'desc'} . $suffix;
    }

    my $tmp = File::Temp->new(
        TEMPLATE => "${date}XXXXXXXX",
        SUFFIX   => $suffix,
        UNLINK   => 1,
        TMPDIR   => 1,
    );
    my $filename = File::Spec->rel2abs($tmp->filename);

    print $tmp $args{text}
        or return (0, "Can't write to tempfile $filename");
    close $tmp
        or return (0, "Can't write to tempfile $filename");

    chmod oct($mode), $filename
        if defined $mode;

    system('scp', '-pq', $filename, "$server:$docroot");

    my ($volume, $dir, $file) = File::Spec->splitpath($filename);
    $file = uri_escape($file);
    $file =~ s/%2b/+/gi;

    return (1, "$topurl/$file");
}

1;

__END__

=head1 NAME

App::Nopaste::Service::ssh - copies files to your server using scp

=head1 AUTHOR

Kevin Falcone C<< <falcone@cpan.org> >>

Thomas Sibley C<< <trs@bestpractical.com> >>

=head1 ENVIRONMENT VARIABLES

=over 4

=item NOPASTE_SSH_SERVER

The hostname to which you ssh. The left-hand side of the colon in the scp.
For example: C<sartak.org>.

=item NOPASTE_SSH_DOCROOT

The path on disk for your pastes. For example: C<public_html/paste>.

=item NOPASTE_SSH_WEBPATH

The path for URLs. For example: C<http://sartak.org/paste>.

=item NOPASTE_SSH_MODE

Octal permissions mode to set for the temporary file before uploading.
For example: C<0644>.

=item NOPASTE_SSH_USE_DESCRIPTION

Use the supplied description in the paste filename for easier identification of
pastes.  Defaults to the source filename, if any, but is overridden by an
explicit C<-d> or C<--description> command line argument.

=back

=head1 APACHE CONFIGURATION RECOMMENDATIONS

The following is a recommended Apache configuration you can drop into
C<.htaccess> in your paste dir.

    RemoveHandler .cgi
    RemoveHandler .pl
    AddDefaultCharset utf-8
    Options -ExecCGI -FollowSymLinks -Includes -MultiViews

It prevents common means of script execution so that C<.pl> and C<.cgi>
files won't run and defaults the character set to UTF-8 so browsers
don't have to guess wrong.

=cut

