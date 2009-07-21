use inc::Module::Install;
name 'HTML-Feature';
all_from 'lib/HTML/Feature.pm';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
