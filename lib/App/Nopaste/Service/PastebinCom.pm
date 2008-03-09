#!/usr/bin/env perl
package App::Nopaste::Service::PastebinCom;
use strict;
use warnings;
use base 'App::Nopaste::Service';
use WWW::PastebinCom::Create;

sub run {
    my $self = shift;
    my %args = @_;

    my $paster = WWW::PastebinCom::Create->new;
    my $ok = $paster->paste(
        text   => $args{text},
        poster => $args{nick},
        format => $args{lang},
        expiry => 'm',
    );

    return (0, $paster->error) unless $ok;
    return (1, $paster->paste_uri);
}

1;

