use strict;
use Test::More ( tests => 9 );
use lib("../../lib");
use Path::Class;
use FindBin qw($Bin);
use HTML::Feature qw(feature);


my $html;
my %data;
for ( 'utf8.html', 'euc-jp.html', 'sjis.html' ){
    my $html = file("$Bin/data", $_)->slurp;

    %data = feature(\$html, {enc_type => 'utf8'});
    is( $data{title}, "タイトル" );
    is( $data{desc}, "ディスクリプション" );
    is( $data{text}, "ハローワールド" );
}

