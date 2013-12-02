# Load the Module::Install bundled in ./inc/
use inc::Module::Install;
use Module::Install::GithubMeta;
use Module::Install::ManifestSkip;
use Module::Install::AutoManifest;

# Define metadata
name           'App-Nopaste';
all_from       'lib/App/Nopaste.pm';
githubmeta;

requires       'WWW::Mechanize';
requires       'Module::Pluggable';
requires       'Getopt::Long::Descriptive' => '0.090';
requires       'Class::Load';
requires       'URI::Escape';
requires       'JSON';

features(
    'pastebin.com support' => [
        'WWW::Pastebin::PastebinCom::API',
    ],
    'copying of URLs with -x/--copy' => [
        'Clipboard',
    ],
    'copy files to remote server with scp' => [
        'File::Temp',
        'File::Spec'
    ],
    'open URLs in a browser' => [
        'Browser::Open',
    ],
);

install_script 'bin/nopaste';

auto_install;
manifest_skip;
auto_manifest;
WriteAll;

