package App::Nopaste::Service::Pastie;
use strict;
use warnings;
use base 'App::Nopaste::Service';

sub uri { 'http://pastie.caboo.se/pastes/create' }

sub fill_form {
    my $self = shift;
    my $mech = shift;
    my %args = @_;

    $mech->form_number(2); # first is search

    $mech->submit_form(
        fields        => {
            "paste[body]"          => $args{text},
            "paste[parser_id]"     => $args{lang},
            "paste[authorization]" => 'burger', # set with JS to avoid bots
        },
    );
}

sub return {
    my $self = shift;
    my $mech = shift;

    my ($id) = $mech->title =~ /\#(\d+)/;
    return (0, "Could not construct paste link.") if !$id;
    return (1, "http://pastie.org/$id");
}

1;

