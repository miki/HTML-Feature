use strict;
use warnings;
use HTML::Feature;
use Test::More;

my $f = HTML::Feature->new(
    user_agent => 'HTML-Feature',
);
my $text = $f->parse("http://www.ugtop.com/spill.shtml")->text;

if(!$text){
    plan skip_all => ":can't get content by http";
}
else{
    plan tests => 1;
    my $result = $text =~ /HTML-Feature/;
    is($result, 1, "UserAgent name is OK");
}

