#!/usr/bin/env perl
package App::Nopaste::Command;
use Moose;
with 'MooseX::Getopt';

use App::Nopaste;

has desc => (
    traits      => ['Getopt'],
    is          => 'rw',
    isa         => 'Str',
    cmd_aliases => ['description', 'd'],
);

has nick => (
    traits      => ['Getopt'],
    is          => 'rw',
    isa         => 'Str',
    cmd_aliases => ['nickname', 'name', 'n'],
);

has lang => (
    traits      => ['Getopt'],
    is          => 'rw',
    isa         => 'Str',
    default     => 'perl',
    cmd_aliases => ['language', 'l'],
);

has chan => (
    traits      => ['Getopt'],
    is          => 'rw',
    isa         => 'Str',
    cmd_aliases => ['channel'],
);

has services => (
    traits      => ['Getopt'],
    is          => 'rw',
    isa         => 'ArrayRef[Str]',
    cmd_aliases => ['service', 's'],
);

has copy => (
    traits      => ['Getopt'],
    is          => 'rw',
    isa         => 'Bool',
    cmd_aliases => ['x'],
);

has quiet => (
    traits      => ['Getopt'],
    is          => 'rw',
    isa         => 'Bool',
    cmd_aliases => ['q'],
);

sub run {
    my $self = shift;
    my $text = $self->read_text;

    my %args = (
        text     => $text,
        desc     => $self->desc,
        nick     => $self->nick,
        lang     => $self->lang,
        chan     => $self->chan,
        services => $self->services,
    );

    $args{error_handler} = $args{warn_handler} = sub { }
        if $self->quiet;

    my $url = App::Nopaste->nopaste(%args);

    if ($self->copy) {
        require Clipboard;
        Clipboard->copy($url);
    }

    return $url;
}

sub read_text {
    my $self = shift;

    local @ARGV = @{ $self->extra_argv };
    local $/;
    return <>;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

