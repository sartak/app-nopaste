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
    my $ua = LWP::UserAgent->new;

    my %auth = $self->_get_auth;

    my $res = $ua->post(
      'https://gist.github.com/api/v1/json/new',
      {
        'file_ext[gistfile1]'      => '.' . ( $arg{lang} || 'txt' ),
        'file_contents[gistfile1]' => $arg{text},
        %auth,
        defined $arg{private} ?  (private => 1) : (),
        defined $arg{desc} ? (description => $arg{desc}) : (),
      },
    );

    return $self->return($res);
}

sub _get_auth {
    my ($self) = @_;

    if ($ENV{GITHUB_USER} && $ENV{GITHUB_TOKEN}) {
        my $user  = $ENV{GITHUB_USER};
        my $token = $ENV{GITHUB_TOKEN};

        return (
            login => $user,
            token => $token,
        );
    } elsif (eval "require Git; 1") {
        my $user  = Git::config('github.user');
        my $token = Git::config('github.token');

        return unless $user and $token;

        return (
            login => $user,
            token => $token,
        );
    } elsif (eval "require Config::GitLike; 1") {
        my $gitconfig = Config::GitLike->new( confname => 'gitconfig' );
        $gitconfig->load;
        my $user  = $gitconfig->get( key => 'github.user' );
        my $token = $gitconfig->get( key => 'github.token' );

        return unless $user and $token;

        return (
            login => $user,
            token => $token,
        );
    }

    return;
}

sub return {
    my ($self, $res) = @_;

    if ($res->is_error) {
      return (0, "Failed: " . $res->status_line);
    }

    if (($res->header('Client-Warning') || '') eq 'Internal response') {
      return (0, "LWP Error: " . $res->content);
    }

    my ($id) = $res->content =~ qr{"repo":"([0-9a-f]+)"};

    return (0, "Could not find paste link.") if !$id;
    return (1, "http://gist.github.com/$id");
}

1;

__END__

=head1 NAME

App::Nopaste::Service::Gist - http://gist.github.com/

=head1 AUTHOR

Ricardo SIGNES, C<< <rjbs@cpan.org> >>

=cut

