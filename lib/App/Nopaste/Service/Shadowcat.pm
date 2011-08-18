package App::Nopaste::Service::Shadowcat;
use strict;
use warnings;
use base 'App::Nopaste::Service';

sub available {
    my $self = shift;
    my %args = @_;
    return !(exists($args{private}) && $args{private});
}

sub uri { "http://paste.scsys.co.uk" }

1;

__END__

=head1 NAME

App::Nopaste::Service::Shadowcat - http://paste.scsys.co.uk/

=cut

