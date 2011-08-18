package App::Nopaste::Service::Codepeek;
use strict;
use warnings;
use base 'App::Nopaste::Service';

sub uri { 'http://codepeek.com/paste' }

sub fill_form {
    my $self = shift;
    my $mech = shift;
    my %args = @_;

    $mech->form_number(1);

    $mech->submit_form(
        fields => {
            'paste'    => $args{text},
            'language' => ucfirst $args{lang},
            'privacy'  => $args{private},
        },
    );
}

sub return {
    my $self = shift;
    my $mech = shift;

    my $link = $mech->find_link( text_regex => qr#^http://codepeek.com/paste/[a-z0-9]+$#i );
    my $url = $link->url;
    return (0, "Could not construct paste link.") if !$url;
    return (1, $url);
}

1;

__END__

=head1 NAME

App::Nopaste::Service::Codepeek - http://codepeek.com

=head1 AUTHOR

Justin Hunter, C<< <justin.d.hunter@gmail.com> >>

=cut

