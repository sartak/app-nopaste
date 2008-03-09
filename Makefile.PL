# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'App-Nopaste';
all_from       'lib/App/Nopaste.pm';

requires       '';

build_requires 'Test::More';

auto_install;
WriteAll;

