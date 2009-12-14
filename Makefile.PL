# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'App-Nopaste';
all_from       'lib/App/Nopaste.pm';
githubmeta;

requires       'WWW::Mechanize';
requires       'Module::Pluggable';
requires       'Moose' => '0.74';
requires       'MooseX::Getopt' => '0.17';

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
    'Github authentication (having Git installed works too)' => [
        'Config::INI::Reader' => '0.00',
    ],
    'copy files to remote server with scp' => [
        'File::Temp',
        'File::Spec'
    ],
);

install_script 'bin/nopaste';

auto_install;
WriteAll;

