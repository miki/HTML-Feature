use strict;
use warnings;
use HTML::Feature::Fetcher;
use Test::More tests => 4;

my $fetcher = HTML::Feature::Fetcher->new;

isa_ok($fetcher, 'HTML::Feature::Fetcher');
isa_ok($fetcher->fetcher, 'LWP::UserAgent');

can_ok($fetcher, 'new');
can_ok($fetcher, 'request');