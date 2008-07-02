# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'App-Nopaste';
all_from       'lib/App/Nopaste.pm';

requires       'WWW::Mechanize';
requires       'Module::Pluggable';
requires       'Moose' => '0.50';
requires       'MooseX::Getopt' => '0.13';

features(
    'pastebin.com support' => [
        'WWW::Pastebin::PastebinCom::Create',
    ],
    'rafb.net support' => [
        'WWW::Pastebin::RafbNet::Create',
    ],
    'copying of URLs with -x/--copy' => [
        'Clipboard',
    ],
);

build_requires 'Test::More';

install_script 'bin/nopaste';

auto_install;
WriteAll;

