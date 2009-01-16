package App::Nopaste::Service::Gist;
use strict;
use warnings;
use base 'App::Nopaste::Service';

sub available         { 1 }
sub forbid_in_default { 0 }

sub nopaste {
    my $self = shift;
    $self->run(@_);
}

sub run {
    my ($self, %arg) = @_;
    my $mech = WWW::Mechanize->new;

    $mech->get('http://gist.github.com');
    $mech->submit_form(
        form_number => 1,
        fields      => {
            'file_name[gistfile1]'     => 'paste.' . ($arg{lang} || 'txt'),
            'file_contents[gistfile1]' => $arg{text},
        },
    );

    return $self->return($mech => @_);
}

sub return {
    my $self = shift;
    my $mech = shift;

    my $link = $mech->find_link(url_regex => qr{/delete/\d+})
        || die $mech->content;
    my ($id) = $link->url =~ m{/delete/(\d+)};

    return (0, "Could not find paste link.") if !$link;
    return (1, "http://gist.github.com/$id");
}

1;

=head1 NAME

App::Nopaste::Service::Gist - http://gist.github.com/

=head1 AUTHOR

Ricardo SIGNES, C<< <rjbs@cpan.org> >>

=cut

