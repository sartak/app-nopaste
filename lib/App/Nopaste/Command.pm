package App::Nopaste::Command;

use strict;
use warnings;

use Getopt::Long::Descriptive ();

use App::Nopaste;

sub new_with_options {
    my $class = shift;
    my ($opt, $usage) = Getopt::Long::Descriptive::describe_options(
       "$0 %o",
       ['help|usage|?|h', 'Prints this usage information' ],
       ['desc|description|d=s',
    'The one line description of your paste. The default is usually the first few characters of your text.'
       ],
       ['nick|nickname|name|n=s', 'Your nickname, usually displayed with the paste.'],

       ['lang|language|l=s', 'The language of the nopaste. Default: perl.',
          { default       => 'perl' },
       ],

       ['chan|channel|c=s',
    'The channel for the nopaste, not always relevant. Usually tied to a pastebot in that channel which will announce your paste.',
       ],

       ['services|service|s=s',
    'The nopaste services to try, in order. You may also specify this in the env var NOPASTE_SERVICES.',
       ],

       ['list_services|list|L', 'List available nopaste services'],

       ['copy|x', 'If specified, automatically copy the URL to your clipboard.'],

       ['paste|p', 'If specified, use only the clipboard as input.'],

       ['open_url|open|o', 'If specified, automatically open the URL using Browser::Open.'],

       ['quiet|q', 'If specified, do not warn or complain about broken services.'],

       ['private', 'If specified, paste privately to services where possible.'],
    );

    print($usage->text), exit if $opt->help;

    my $self = $class->new({
       extra_argv => [@ARGV],
       map { $_ => $opt->$_ } qw(
         desc nick lang chan list_services copy paste open_url quiet private services
       ),
    });
}

sub new {
   my $class = shift;
   my $self;
   if (!ref $_[0]) {
      $self = { @_ };
   } else {
      $self = $_[0]
   }

   $self->{services} = [ split /\s+/, $self->{services} ]
      if defined $self->{services} && !ref $self->{services};

   bless $self, $class;

   return $self
}
my @acc = qw(
    desc nick lang chan list_services copy paste open_url quiet private usage
    extra_argv services
);
for my $a (@acc) {
   no strict 'refs';

   *{__PACKAGE__ . '::' . $a } = sub { $_[0]->{$a} }
}
sub filename {
    my $self  = shift;
    my @files = @{ $self->extra_argv };

    return undef unless @files;
    return undef if $self->paste or $files[0] eq '-';
    return $files[0];
}

sub run {
    my $self = shift;

    if ($self->list_services) {
        for (sort App::Nopaste->plugins) {
            s/App::Nopaste::Service::(\w+)$/$1/;
            print $_, "\n";
        }
        exit 0;
    }

    my $text = $self->read_text;
    utf8::decode($text);

    my %args = map { $_ => $self->$_ } @acc, qw(filename);

    $args{text} ||= $text;

    $args{error_handler} = $args{warn_handler} = sub { }
        if $self->quiet;

    my $url = App::Nopaste->nopaste(%args);

    if ($self->copy) {
        require Clipboard;
        Clipboard->import;
        Clipboard->copy($url);
    }

    if ($self->open_url) {
        require Browser::Open;
        Browser::Open::open_browser($url);
    }

    return $url;
}

sub read_text {
    my $self = shift;

    if ($self->paste && @{ $self->extra_argv }) {
        die "You may not specify --paste and files simultaneously.\n";
    }

    if ($self->paste) {
        require Clipboard;
        Clipboard->import;
        return Clipboard->paste;
    }

    local @ARGV = @{ $self->extra_argv };
    local $/;
    return <>;
}

1;

__END__

=head1 NAME

App::Nopaste::Command - command-line utility for L<App::Nopaste>

nopaste - command-line utility to nopaste

=head1 DESCRIPTION

This application will take some text on STDIN and give you a URL on STDOUT.

You may also specify files as arguments, they will be concatenated together
into one large nopaste.

=head1 OPTIONS

=head2 -d, --desc

The one line description of your paste. The default is usually the first few
characters of your text.

=head2 -n, --name

Your nickname, usually displayed with the paste. Default: C<$NOPASTE_NICK> then
C<$USER>.

=head2 -l, --lang

The language of the nopaste. The values accepted depend on the nopaste service.
There is no mapping done yet. Default: perl.

=head2 -c, --chan

The channel for the nopaste, not always relevant. Usually tied to a pastebot in that channel which will announce your paste.

=head2 -s, --services

The nopaste services to try, in order. You may also specify this in C<$NOPASTE_SERVICES> (space-separated list of service names, e.g. C<Shadowcat Gist>).

=head2 -L, --list

List available nopaste services.

=head2 -x, --copy

If specified, automatically copy the URL to your clipboard, using the
L<Clipboard> module.

=head2 -p, --paste

If specified, use only the clipboard as input, using the L<Clipboard> module.

=head2 -o, --open

If specified, automatically open the URL using L<Browser::Open>.  Browser::Open
tries a number of different browser commands depending on your OS.

=head2 --private

If specified, the paste access will be restricted to those that know the URL.

=head2 -q, --quiet

If specified, do not warn or complain about broken services.

=cut
