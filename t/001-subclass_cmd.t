use strict;
use warnings;
use Test::More;

{
    package App::Nopaste::Service::_MyTest;
    use base 'App::Nopaste::Service';

    sub available { 1 }
    sub uri { 'test' }
    sub run {
        shift;
        my %a = @_;
        return (1, \%a);
    }
}

{
    package _MyTest::Cmd;
    use base 'App::Nopaste::Command';

    sub read_text { 'test' }
}

my $input = {
    desc => 'a test',
    nick => 'person',
    lang => 'text',
    services => ['App::Nopaste::Service::_MyTest'],
    extra_argv => []
};

my $cmd = _MyTest::Cmd->new($input);
isa_ok($cmd,'App::Nopaste::Command');

my $ret = $cmd->run;
ok(ref($ret) eq 'HASH') or diag $ret;

is($ret->{nick}, $input->{nick});
is($ret->{lang}, $input->{lang});
is($ret->{services}, $input->{services});
is($ret->{text},'test');

done_testing;

