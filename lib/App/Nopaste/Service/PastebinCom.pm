#!/usr/bin/env perl
package App::Nopaste::Service::PastebinCom;
use strict;
use warnings;
use base 'App::Nopaste::Service';
use WWW::PastebinCom::Create;

sub run {
    my $self = shift;
    my %args = @_;

    $args{poster} = delete $args{nick} if defined $args{nick};
    $args{format} = delete $args{lang} if defined $args{lang};

    my $paster = WWW::PastebinCom::Create->new;
    my $ok = $paster->paste(
        expiry => 'm',
        %args,
    );

    return (0, $paster->error) unless $ok;
    return (1, $paster->paste_uri);
}

=head1 NAME

App::Nopaste::Service::PastebinCom - http://pastebin.com/

=head1 SEE ALSO

L<WWW::PastebinCom::Create>

=cut

1;

