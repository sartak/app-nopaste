package App::Nopaste::Service::Debian;
use strict;
use warnings;
use base 'App::Nopaste::Service';

sub uri { "http://paste.debian.net/" }

sub fill_form {
    my $self = shift;
    my $mech = shift;
    my %args = @_;

    $mech->form_number(1);
    $mech->submit_form(
        fields        => {
            code => $args{text},
            do { $args{nick} ? (poster => $args{nick}) : () },
        },
    );
}

sub return {
    my $self = shift;
    my $mech = shift;

    my $link = $mech->uri();

    return (1, $link);
}

1;

__END__

=head1 NAME

App::Nopaste::Service::Debian - http://paste.debian.net/

=head1 AUTHOR

Ryan Niebur, C<< <ryanryan52@gmail.com> >>

=cut

