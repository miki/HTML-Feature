use strict;

use lib("../../lib");
use HTML::Feature;
use Test::More ( tests => 6 ); 
use Path::Class;
use FindBin qw($Bin);

my $html = file("$Bin/data", 'utf8.html')->slurp;

my $f = HTML::Feature->new;
my $result = $f->parse(\$html, {element_flag => 1});
ok($result);
ok($result->element);
isa_ok($result->{element}, 'HTML::Element');

$f = HTML::Feature->new(element_flag => 1);
$result = $f->parse(\$html);
ok($result);
ok($result->element);
isa_ok($result->{element}, 'HTML::Element');

