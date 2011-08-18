package App::Nopaste::Service;
use strict;
use warnings;
use WWW::Mechanize;

sub available         { 1 }
sub forbid_in_default { 0 }

# this wrapper is so we can canonicalize arguments, especially "lang"
sub nopaste {
    my $self = shift;
    $self->run(@_);
}

sub run {
    my $self = shift;
    my $mech = WWW::Mechanize->new;

    $self->get($mech => @_);
    $self->fill_form($mech => @_);
    return $self->return($mech => @_);
}

sub uri {
    my $class = ref($_[0]) || $_[0];
    Carp::croak "$class must provide a 'uri' method.";
}

sub get {
    my $self = shift;
    my $mech = shift;

    my $res = $mech->get($self->uri);
    die "Unable to fetch ".$self->uri.": " . $res->status_line
        unless $res->is_success;
    return $res;
}

sub fill_form {
    my $self = shift;
    my $mech = shift;
    my %args = @_;

    $mech->form_number(1);
    $args{chan} = $self->canonicalize_chan($mech, $args{chan});

    $mech->submit_form(
        fields        => {
            paste => $args{text},
            do { $args{chan} ? (channel => $args{chan}) : () },
            do { $args{desc} ? (summary => $args{desc}) : () },
            do { $args{nick} ? (nick    => $args{nick}) : () },
            private => (exists $args{private} && $args{private} ? 1 : 0),
        },
    );
}

sub canonicalize_chan {
    my $self = shift;
    my $mech = shift;
    my $chan = shift;

    return $chan if !$chan;

    my @chans = grep { length }
                $mech->current_form->find_input('channel')->possible_values;
    my %is_valid = map { $_ => 1 } @chans;

    return $chan if $is_valid{$chan};

    my $orig = $chan;
    $chan =~ s/^\#//;
    return $chan if $is_valid{$chan};

    $chan = "#$chan";
    return $chan if $is_valid{$chan};

    warn "Invalid channel '$orig'. Valid values are: " . join(', ', @chans);
    return $orig;
}

sub return {
    my $self = shift;
    my $mech = shift;

    my $link = $mech->find_link(url_regex => qr{/?(?:\d+)$});

    return (0, "Could not find paste link.") if !$link;
    return (1, $link->url);
}

=head1 NAME

App::Nopaste::Service - base class for nopaste services

=head1 SYNOPSIS

    package App::Nopaste::Service::Shadowcat;
    use base 'App::Nopaste::Service';

    sub uri { "http://paste.scsys.co.uk/" }

=head1 DESCRIPTION

C<App::Nopaste::Service> defines a generic interface for uploading to nopaste
sites. It provides a default interface to that of the POE Pastebot.

=head1 METHODS

=head2 nopaste

This is the outermost method called by L<App::Nopaste> and other clients. You
should not override this method, as it will (XXX: eventually) perform
canonicalization of arguments (such as C<lang>) for you.

=head2 run args -> (OK, message)

This is the outermost method you should override. You'll be passed a hash of arguments. The only arguments you should pay attention to are:

=over 4

=item text

The body of text to paste.

=item desc

A short (one-line) summary of the paste.

=item nick

The name of the person performing the paste.

=item chan

The IRC channel to which the paste belongs.

=item lang

The programming language of the body of text.

=item private

If false, the paste will be public (default).

=back

=head2 get mech, args

This should "get" the form to paste using the provided L<WWW::Mechanize>
object. By default it does just that. See L</uri> below.

=head2 uri

If you only need to call C<< mech->get(uri) >> then you may define this method
to provide the URI of the nopaste service.

=head2 fill_form mech, args

This should have the L<WWW::Mechanize> fill in the form using the arguments,
and submit it.

=head2 return mech, args

This should look at C<< WWW::Mechanize->content >> to find the URI to the
pasted text.

=head1 AUTHOR

Shawn M Moore, C<< <sartak at gmail.com> >>

=cut

1;

