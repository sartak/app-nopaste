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

    my %auth = $self->_get_auth;

    $mech->get('http://gist.github.com');
    $mech->submit_form(
        form_number => 1,
        fields      => {
            'file_name[gistfile1]'     => 'paste.' . ($arg{lang} || 'txt'),
            'file_contents[gistfile1]' => $arg{text},
            %auth,
        },
    );

    return $self->return($mech => @_);
}

sub _get_auth {
  my ($self) = @_;

  if (eval "require Git; 1") {
      my $user  = Git::config('github.user');
      my $token = Git::config('github.token');

      return unless $user and $token;

      return (
          user  => $user,
          token => $token,
      );
  } elsif (eval "require Config::INI::Reader; 1") {
      require File::Spec;
      return unless $ENV{HOME};
      my $git_config_filename = File::Spec->catfile($ENV{HOME}, '.gitconfig');
      return unless -r $git_config_filename;
      my $gitconfig = Config::INI::Reader->read_file($git_config_filename);
      my $user  = $gitconfig->{github}{user};
      my $token = $gitconfig->{github}{token};

      return unless $user and $token;

      return (
        user  => $user,
        token => $token,
      );
  }

  return;
}

sub return {
    my $self = shift;
    my $mech = shift;

    my ($id) = $mech->content =~ m{gist: (\d+)\s*-};

    return (0, "Could not find paste link.") if !$id;
    return (1, "http://gist.github.com/$id");
}

1;

=head1 NAME

App::Nopaste::Service::Gist - http://gist.github.com/

=head1 AUTHOR

Ricardo SIGNES, C<< <rjbs@cpan.org> >>

=cut

