use strict;
use warnings;
use HTML::Feature;
use Test::More tests => 1;

my $url           = "http://hogehoge";
my $custom_engine = CustomEngine->new;
my $f             = HTML::Feature->new( engine_obj => $custom_engine, );

my $result = $f->parse($url);
is( $result->{i_know_the_url}, 1, "let the engine recognize url test OK" );

#-----------------------------------------------
package CustomEngine;
use base "HTML::Feature::Engine";
use HTML::Feature::Result;

sub run {
    my $self     = shift;
    my $c        = shift;
    my $html_ref = shift;

    my $i_know_the_url = 0;
    if ( $c->{base_url} eq "http://hogehoge" ) {
        $i_know_the_url = 1;
    }

    my $result = HTML::Feature::Result->new;
    $result->{i_know_the_url} = $i_know_the_url;
    return $result;
}

1;

