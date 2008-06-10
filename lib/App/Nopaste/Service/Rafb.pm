#!/usr/bin/env perl
package App::Nopaste::Service::Rafb;
use strict;
use warnings;
use base 'App::Nopaste::Service';

sub available {
    eval "require WWW::Pastebin::RafbNet::Create; 1"
}

sub run {
    my $self = shift;
    my %args = @_;

    require WWW::Pastebin::RafbNet::Create;

    my $paster = WWW::Pastebin::RafbNet::Create->new;
    my $ok = $paster->paste(
        $args{text},
        %args,
    );

    return (0, $paster->error) unless $ok;
    return (1, $paster->paste_uri);
}

=head1 NAME

App::Nopaste::Service::Rafb - http://www.rafb.net/paste/

=head1 SEE ALSO

L<WWW::Pastebin::RafbNet::Create>

=cut

1;

