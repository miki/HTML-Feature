use strict;
use inc::Module::Install;

name 'HTML-Feature';
all_from 'lib/HTML/Feature.pm';

requires 'Carp';
requires 'LWP::UserAgent';
requires 'HTTP::Response::Encoding';
requires 'Encode::Guess';
requires 'UNIVERSAL::require';
requires 'List::Util';
requires 'Scalar::Util';
requires 'HTML::TreeBuilder';
requires 'Class::Accessor::Fast';
requires 'HTML::TreeBuilder';
requires 'Statistics::Lite';

build_requires 'Test::More';
build_requires 'Path::Class';
build_requires 'FindBin';

tests 't/*.t t/*/*.t'; 

auto_install;
WriteAll;
