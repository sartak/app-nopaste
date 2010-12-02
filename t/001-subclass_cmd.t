package main;

BEGIN {
    use strict;
    use warnings;
    use Test::More;
    
    plan 'no_plan';
    
    use_ok 'App::Nopaste::Service';
    use_ok 'App::Nopaste::Command';
}

my $input = {
    desc => 'a test',
    nick => 'person',
    lang => 'text',
    services => ['App::Nopaste::Service::_MyTest'],
    extra_argv => []
};

my $cmd = eval { _MyTest::Cmd->new($input); };

ok(!$@);
isa_ok($cmd,'App::Nopaste::Command');

my $ret = eval { $cmd->run };

ok(!$@) or diag $@;
ok(ref($ret) eq 'HASH') or diag $ret;

is($ret->{nick}, $input->{nick});
is($ret->{lang}, $input->{lang});
is($ret->{services}, $input->{services});
is($ret->{text},'test');

1;

package App::Nopaste::Service::_MyTest;

BEGIN {
    use base 'App::Nopaste::Service';
    $INC{'App/Nopaste/Service/_MyTest.pm'} = 'spoof';
}

sub available {1};
sub uri { 'test' }
sub run {
    shift;
    my %a = @_;
    return (1, \%a);
}

1;

package _MyTest::Cmd;

BEGIN {
    use Moose; 
    has text => ( is => 'rw', isa => 'Str', default => 'test' );
    extends 'App::Nopaste::Command';
    $INC{'_MyTest/Cmd.pm'} = 'spoof';
}


sub read_text {}

no Moose;
1;
