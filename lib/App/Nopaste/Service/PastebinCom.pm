package App::Nopaste::Service::PastebinCom;
use strict;
use warnings;
use base 'App::Nopaste::Service';

sub available {
    eval "require WWW::Pastebin::PastebinCom::API; 1"
}

sub run {
    my $self = shift;
    my %args = @_;

    require WWW::Pastebin::PastebinCom::API;

    my $text = delete $args{text} if defined $args{text};
    $args{format} = delete $args{lang} if defined $args{lang};

    my $api_key = $ENV{PASTEBIN_API_KEY};

    my $paster = WWW::Pastebin::PastebinCom::API->new(
        api_key => $api_key
    );
    my $ok = $paster->paste(
        $text,
        expiry => '1m',
        %args,
    );

    return (0, $paster->error) unless $ok;
    return (1, $paster->paste_url);
}

1;

__END__

=head1 NAME

App::Nopaste::Service::PastebinCom - http://pastebin.com/

=head1 Pastebin.com Authorization

In order to create pastes to Pastebin.com, you need to get an API key.
Please login to your Pastebin.com account and view
L<http://pastebin.com/api#1> to get your key, and export it as the
C<PASTEBIN_API_KEY> environment variable.

=head1 SEE ALSO

L<WWW::Pastebin::PastebinCom::API>

=cut

