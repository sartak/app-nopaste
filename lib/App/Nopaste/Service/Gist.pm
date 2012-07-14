package App::Nopaste::Service::Gist;
use strict;
use warnings;
use base 'App::Nopaste::Service';

use File::Basename ();
use JSON ();

sub available         { 1 }
sub forbid_in_default { 0 }

sub nopaste {
    my $self = shift;
    $self->run(@_);
}

sub run {
    my ($self, %arg) = @_;
    my $ua = LWP::UserAgent->new;

    my $content = {
        public => defined $arg{private} ? 0 : 1,
        defined $arg{desc} ? (description => $arg{desc}) : (),
    };

    $content->{files} = {
        File::Basename::basename($arg{filename}) => {
            content => $arg{text}
        }
    };

    $content = JSON::encode_json($content);

    my %auth = $self->_get_auth;

    my $res = $ua->post(
        'https://api.github.com/gists',
        'Authorization' => "token $auth{oauth_token}",
        Content         => $content
    );

    return $self->return($res);
}

sub _get_auth {
    my ($self) = @_;

    if (my $oauth_token = $ENV{GITHUB_OAUTH_TOKEN}) {
        return (oauth_token => $oauth_token);
    }

    Carp::croak(
        join "\n",
        "Export GITHUB_OAUTH_TOKEN first. For example:",
        q{curl -X POST 'https://USERNAME:PASSWORD@api.github.com/authorizations'}
          . q(-d '{"scopes":["gist"],"note":"App::Nopaste"}')
    );
}

sub return {
    my ($self, $res) = @_;

    if ($res->is_error) {
      return (0, "Failed: " . $res->status_line);
    }

    if (($res->header('Client-Warning') || '') eq 'Internal response') {
      return (0, "LWP Error: " . $res->content);
    }

    my ($id) = $res->content =~ qr{"id":"([0-9a-f]+)"};

    return (0, "Could not find paste link.") if !$id;
    return (1, "http://gist.github.com/$id");
}

1;

__END__

=head1 NAME

App::Nopaste::Service::Gist - http://gist.github.com/

=head1 GitHub Authorization

In order to create gists you have to get an oauth token. That could be easily
obtained via curl:

    curl -X POST 'https://USERNAME:PASSWORD@api.github.com/authorizations' \
        -d '{"scopes":["gist"],"note":"App::Nopaste"}'

This will grant gist rights to the L<App::Nopaste>, don't worry you can revoke
access rights anytime from the GitHub profile settings. Search for C<token> in
response and export it as C<GITHUB_OAUTH_TOKEN> environment variable.

That's it!

=head1 AUTHOR

Ricardo SIGNES, C<< <rjbs@cpan.org> >>

=cut

