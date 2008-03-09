# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'App-Nopaste';
all_from       'lib/App/Nopaste.pm';

requires       'WWW::Mechanize';
requires       'Module::Pluggable';

features(
    'nopaste to pastebin.com' => [
        -default => 1,
        requires('WWW::PastebinCom::Create'),
    ],
    'nopaste to rafb.net' => [
        -default => 1,
        requires('WWW::Rafb::Create'),
    ],
);

build_requires 'Test::More';

install_script 'nopaste';

auto_install;
WriteAll;

