#!/usr/bin/env perl
package App::Nopaste::Command;
use Moose;
with 'MooseX::Getopt';

use App::Nopaste;

has desc => (
    is  => 'rw',
    isa => 'Str',
);

has nick => (
    is      => 'rw',
    isa     => 'Str',
    default => sub { $ENV{USER} },
);

has lang => (
    is      => 'rw',
    isa     => 'Str',
    default => 'perl',
);

has chan => (
    is      => 'rw',
    isa     => 'Str',
);

has copy => (
    is  => 'rw',
    isa => 'Bool',
);

sub run {
    my $self = shift;
    my $text = $self->read_text;

    my $url  = App::Nopaste->nopaste(
        text => $text,
        desc => $self->desc,
        nick => $self->nick,
        lang => $self->lang,
        chan => $self->chan,
    );

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

