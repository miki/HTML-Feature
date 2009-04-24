use strict;
use Test::More ( tests => 2 );
#use lib("../lib");

use HTML::Feature;

my $f = HTML::Feature->new();
isa_ok($f, 'HTML::Feature');
 
my @method = qw( parse parse_url parse_html parse_response feature );
can_ok($f,@method);


