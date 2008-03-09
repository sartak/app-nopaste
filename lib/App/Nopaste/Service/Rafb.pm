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
        %args,
    );

    return (0, $paster->error) unless $ok;
    return (1, $paster->uri);
}

=head1 NAME

App::Nopaste::Service::Rafb - http://www.rafb.net/paste/

=head1 SEE ALSO

L<WWW::Rafb::Create>

=cut

1;

