#!perl -T
use strict;
use warnings;
use Test::More tests => 5;

use_ok 'App::Nopaste';
use_ok 'App::Nopaste::Service';
use_ok 'App::Nopaste::Service::Shadowcat';
use_ok 'App::Nopaste::Service::Husk';
use_ok 'App::Nopaste::Service::Snitch';

