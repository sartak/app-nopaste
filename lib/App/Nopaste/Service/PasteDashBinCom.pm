package App::Nopaste::Service::PasteDashBinCom;
use strict;
use warnings;
use base 'App::Nopaste::Service';

sub uri { 'http://paste-bin.com/' }

sub fill_form {
    my $self = shift;
    my $mech = shift;
    my %args = @_;

    $mech->submit_form(
        with_fields => {
            code   => $args{text},
            lang   => $args{lang},
            name   => $args{nick},
            title  => $args{desc},
            submit => '1'
        },
        button => 'submit',
    );

    die "Failed to submit form: ", $mech->response->status_line
        unless $mech->success;
}

sub return {
    my $self = shift;
    my $mech = shift;

    return (1, $mech->uri());
}

1;

__END__

=head1 NAME

App::Nopaste::Service::PasteDashBinCom - http://paste-bin.com

=head1 AUTHOR

Sebastian Paaske Tørholm, C<< <eckankar@gmail.com> >>

=cut

