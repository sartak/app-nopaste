package App::Nopaste::Command;
use Moose;
with 'MooseX::Getopt';

use App::Nopaste;

has desc => (
    traits        => ['Getopt'],
    is            => 'rw',
    isa           => 'Str',
    cmd_aliases   => ['description', 'd'],
    documentation => "The one line description of your paste. The default is usually the first few characters of your text.",
);

has nick => (
    traits        => ['Getopt'],
    is            => 'rw',
    isa           => 'Str',
    cmd_aliases   => ['nickname', 'name', 'n'],
    documentation => "Your nickname, usually displayed with the paste.",
);

has lang => (
    traits        => ['Getopt'],
    is            => 'rw',
    isa           => 'Str',
    default       => 'perl',
    cmd_aliases   => ['language', 'l'],
    documentation => "The language of the nopaste. Default: perl.",
);

has chan => (
    traits        => ['Getopt'],
    is            => 'rw',
    isa           => 'Str',
    cmd_aliases   => ['channel', 'c'],
    documentation => "The channel for the nopaste, not always relevant. Usually tied to a pastebot in that channel which will announce your paste.",
);

has services => (
    traits        => ['Getopt'],
    is            => 'rw',
    isa           => 'ArrayRef[Str]',
    cmd_aliases   => ['service', 's'],
    documentation => "The nopaste services to try, in order. You may also specify this in the env var NOPASTE_SERVICES.",
);

has list_services => (
    traits        => ['Getopt'],
    is            => 'rw',
    isa           => 'Bool',
    cmd_aliases   => ['list', 'L'],
    documentation => "List available nopaste services",
);

has copy => (
    traits        => ['Getopt'],
    is            => 'rw',
    isa           => 'Bool',
    cmd_aliases   => ['x'],
    documentation => "If specified, automatically copy the URL to your clipboard.",
);

has paste => (
    traits        => ['Getopt'],
    is            => 'rw',
    isa           => 'Bool',
    cmd_aliases   => ['p'],
    documentation => "If specified, use only the clipboard as input.",
);

has open_url => (
    traits        => ['Getopt'],
    is            => 'rw',
    isa           => 'Bool',
    cmd_aliases   => ['open', 'o'],
    documentation => "If specified, automatically open the URL using Browser::Open.",
);

has quiet => (
    traits        => ['Getopt'],
    is            => 'rw',
    isa           => 'Bool',
    cmd_aliases   => ['q'],
    documentation => "If specified, do not warn or complain about broken services.",
);

has private => (
    traits        => ['Getopt'],
    is            => 'rw',
    isa           => 'Bool',
    documentation => "If specified, paste privately to services where possible.",
);

has filename => (
    is            => 'rw',
    isa           => 'Maybe[Str]',
    builder       => 'detect_filename'
);

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

    my %args = map {
        $_->name => $_->get_value($self)
    } $self->meta->get_all_attributes;

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

sub detect_filename {
    my $self  = shift;
    my @files = @{ $self->extra_argv };

    return undef unless @files;
    return undef if $self->paste or $files[0] eq '-';
    return $files[0];
}

__PACKAGE__->meta->make_immutable;
no Moose;

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
