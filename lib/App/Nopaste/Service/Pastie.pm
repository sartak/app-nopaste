package App::Nopaste::Service::Pastie;
use strict;
use warnings;
use base 'App::Nopaste::Service';

sub uri { 'http://pastie.org/' }

sub fill_form {
    my $self = shift;
    my $mech = shift;
    my %args = @_;

    $mech->submit_form(
        fields => {
            "paste[body]"          => $args{text},
            "paste[authorization]" => 'burger', # set with JS to avoid bots
            "paste[restricted]"    => $args{private},

            # this doesn't work because they use numeric IDs for language
            #"paste[parser_id]"     => $args{lang},
        },
    );
}

sub return {
    my $self = shift;
    my $mech = shift;

    my $prefix ='';
    my ($id) = $mech->title =~ /\#(\d+)/;
    if (!$id) {
        ($id) = $mech->content =~ m{http://pastie.org/\d+/wrap\?key=([a-z0-9]+)};
        $prefix = 'private/';
    }
    return (0, "Could not construct paste link.") if !$id;
    return (1, "http://pastie.org/$prefix$id");
}

1;

__END__

=head1 NAME

App::Nopaste::Service::Pastie - http://pastie.org

=cut

