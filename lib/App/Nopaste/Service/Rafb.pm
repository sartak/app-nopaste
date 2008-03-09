#!/usr/bin/env perl
package App::Nopaste::Service::Rafb;
use strict;
use warnings;
use base 'App::Nopaste::Service';
use WWW::Rafb::Create;

sub run {
    my $self = shift;
    my %args = @_;

    my $paster = WWW::Rafb::Create->new;
    my $ok = $paster->paste(
        $args{text},
        nick => $args{nick},
        desc => $args{desc},
        tabs => $args{tabs},
        lang => $args{lang},
    );

    return (0, $paster->error) unless $ok;
    return (1, $paster->uri);
}

1;

