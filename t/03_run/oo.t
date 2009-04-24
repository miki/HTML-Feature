use strict;
use Test::More ( tests => 12 );
use lib("../../lib");
use Path::Class;
use FindBin qw($Bin);
use HTML::Feature;


my $html;
my $f = HTML::Feature->new(enc_type => 'utf8');

for ( 'utf8.html', 'euc-jp.html', 'sjis.html' ){
    my $html = file("$Bin/data", $_)->slurp;
    my $result = $f->parse(\$html);
    isa_ok($result, 'HTML::Feature::Result');
    is( $result->title(), "タイトル" );
    is( $result->desc(), "ディスクリプション" );
    is( $result->text(),  "ハローワールド" );
}

