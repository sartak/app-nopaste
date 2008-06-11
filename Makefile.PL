# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'App-Nopaste';
all_from       'lib/App/Nopaste.pm';

requires       'WWW::Mechanize';
requires       'Module::Pluggable';

features(
    'pastebin.com support' => [
        'WWW::Pastebin::PastebinCom::Create',
    ],
    'rafb.net support' => [
        'WWW::Pastebin::RafbNet::Create',
    ],
);

build_requires 'Test::More';

install_script 'bin/nopaste';

auto_install;
WriteAll;

