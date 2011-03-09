use strict;
use warnings;
use Test::More tests => 10;

use_ok 'App::Nopaste';
use_ok 'App::Nopaste::Service';
use_ok 'App::Nopaste::Service::Codepeek';
use_ok 'App::Nopaste::Service::Debian';
use_ok 'App::Nopaste::Service::Gist';
use_ok 'App::Nopaste::Service::PastebinCom';
use_ok 'App::Nopaste::Service::Pastie';
use_ok 'App::Nopaste::Service::Shadowcat';
use_ok 'App::Nopaste::Service::Snitch';
use_ok 'App::Nopaste::Service::ssh';
