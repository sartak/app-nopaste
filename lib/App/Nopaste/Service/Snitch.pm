package App::Nopaste::Service::Snitch;
use strict;
use warnings;
use base 'App::Nopaste::Service';

sub available {
    my $self = shift;
    my %args = @_;
    return !(exists($args{private}) && $args{private});
}

sub uri { "http://nopaste.snit.ch" }

1;

__END__

=head1 NAME

App::Nopaste::Service::Snitch - http://nopaste.snit.ch/

=cut

