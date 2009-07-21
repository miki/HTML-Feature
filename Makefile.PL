use inc::Module::Install;
name 'HTML-Feature';
all_from 'lib/HTML/Feature.pm';

requires 'Carp';
requires 'LWP::UserAgent';
requires 'Scalar::Util';
requires 'HTML::TreeBuilder';
requires 'Class::Accessor::Fast';
requires 'Statistics::Lite';
requires 'URI';
requires 'Class::Data::ConfigHash';
requires 'Data::Decode';
 
build_requires 'Test::More';
build_requires 'Path::Class';
build_requires 'FindBin';
 
tests 't/*.t t/*/*.t'; 

use_test_base;
auto_include;
WriteAll;
