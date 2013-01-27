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

    my $filename = defined $arg{filename}
                 ? File::Basename::basename($arg{filename})
                 : 'nopaste';

    $content->{files} = {
        $filename => {
            content => $arg{text}
        }
    };

    $content = JSON::encode_json($content);

    my %auth = $self->_get_auth;

    my $url = 'https://api.github.com/gists';

    my $res = do {
        if ($auth{oauth_token}) {
            $ua->post(
                $url,
                'Authorization' => "token $auth{oauth_token}",
                Content         => $content
            );
        }
        else {
            require HTTP::Request::Common;
            my $req = HTTP::Request::Common::POST($url, Content => $content);
            $req->authorization_basic(@auth{qw/username password/});
            $ua->request($req);
        }
    };

    return $self->return($res);
}

sub _get_auth {
    my ($self) = @_;

    if (my $oauth_token = $ENV{GITHUB_OAUTH_TOKEN}) {
        return (oauth_token => $oauth_token);
    }
    elsif ($ENV{GITHUB_USER} && $ENV{GITHUB_PASSWORD}) {
        return (
            username => $ENV{GITHUB_USER},
            password => $ENV{GITHUB_PASSWORD},
        );
    }

    die join("\n",
        "Export GITHUB_OAUTH_TOKEN first. For example:",
        "    perl -Ilib -MApp::Nopaste::Service::Gist -e 'App::Nopaste::Service::Gist->create_token'",
        "",
        "OR you can export GITHUB_USER and GITHUB_PASSWORD.",
    ) . "\n";
}

sub create_token {
    my ($self) = @_;

    local $| = 1;
    print "Username: ";
    chomp(my $username = <>);
    print "Password: ";
    chomp(my $password = <>);
    print "\n\n";

    exit unless $username && $password;

    my $parameters = {
        scopes   => ["gist"],
        note     => "App::Nopaste",
        note_url => "https://metacpan.org/module/App::Nopaste",
    };

    my $ua = LWP::UserAgent->new;

    my $request = HTTP::Request->new(POST => 'https://api.github.com/authorizations');
    $request->authorization_basic($username, $password);
    $request->content(JSON::encode_json($parameters));

    my $response = $ua->request($request);

    my $response_content = JSON::decode_json($response->decoded_content);

    if ($response_content->{token} ) {
        print "GITHUB_OAUTH_TOKEN=$response_content->{token}\n";
    }
    else {
        print $response_content->{message} || "Unspecified error", "\n";
    }
}

sub return {
    my ($self, $res) = @_;

    if ($res->is_error) {
        my $text = $res->status_line;
        if ($res->code == 401) {
            $text .= "\nYou may need to authorize $0. See `perldoc " . __PACKAGE__ . "`";
        }
        return (0, "Failed: " . $text);
    }

    if (($res->header('Client-Warning') || '') eq 'Internal response') {
      return (0, "LWP Error: " . $res->content);
    }

    my $id = JSON::decode_json($res->content)->{id};

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

or you can use this module to do the same:

    perl -MApp::Nopaste::Service::Gist -e 'App::Nopaste::Service::Gist->create_token'

This will grant gist rights to the L<App::Nopaste>, don't worry you can revoke
access rights anytime from the GitHub profile settings. Search for C<token> in
response and export it as C<GITHUB_OAUTH_TOKEN> environment variable.

Alternatively, you can export the C<GITHUB_USER> and C<GITHUB_PASSWORD>
environment variables, just like for the
L<gist|https://github.com/defunkt/gist> utility.

That's it!

=head1 AUTHOR

Ricardo SIGNES, C<< <rjbs@cpan.org> >>

=cut

