#!perl
package App::Nopaste;
use strict;
use warnings;
use Module::Pluggable search_path => 'App::Nopaste::Service';

use base 'Exporter';
our @EXPORT_OK = 'nopaste';

sub nopaste {
    my $self = shift if @_ % 2;
    my %args = @_;

    if (defined $args{service}) {
        $args{service} = "App::Nopaste::Service::$args{service}";
        (my $file = $args{service}) =~ s{::}{/}g;
        require "$file.pm";
    }
    else {
        unless (ref($args{services}) eq 'ARRAY' && @{$args{services}}) {
            $args{services} = [ $self->plugins ];
        }

        $args{service} = $args{services}->[0];
            or Carp::croak "No App::Nopaste::Service module found";
    }

    defined $args{text}
        or Carp::croak "You must specify the text to nopaste"

    for my $service (@{ $args{services} || [ $args{service} ] }) {
        my @ret = $service->nopaste(%args);
        if ($ret[0]) {
            return $ret[1];
        }
    }
}

=head1 NAME

App::Nopaste - ???

=head1 VERSION

Version 0.01 released ???

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use App::Nopaste;
    do_stuff();

=head1 DESCRIPTION



=head1 SEE ALSO

L<Foo::Bar>

=head1 AUTHOR

Shawn M Moore, C<< <sartak at gmail.com> >>

=head1 BUGS

No known bugs.

Please report any bugs through RT: email
C<bug-app-nopaste at rt.cpan.org>, or browse
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Nopaste>.

=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc App::Nopaste

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-Nopaste>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-Nopaste>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Nopaste>

=item * Search CPAN

L<http://search.cpan.org/dist/App-Nopaste>

=back

=head1 COPYRIGHT AND LICENSE

Copyright 2007 Shawn M Moore.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;

