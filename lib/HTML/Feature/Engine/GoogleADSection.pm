package HTML::Feature::Engine::GoogleADSection;
use strict;
use warnings;
use HTML::TreeBuilder::LibXML;
use HTML::Feature::Result;
use base qw(HTML::Feature::Base);

sub run {
    my $self     = shift;
    my $html_ref = shift;
    my $result   = HTML::Feature::Result->new;

    my $tree = HTML::TreeBuilder::LibXML->new;
    $tree->parse($$html_ref);
    $tree->eof;

    if ( my $title = $tree->findvalue('//title') ) {
        $result->title($title);
    }
    if ( my $desc = $tree->look_down( _tag => 'meta', name => 'description' ) )
    {
        my $string = $desc->attr('content');
        $string =~ s{<br>}{}xms;
        $result->desc($string);
    }

    my $regexp =
'<!--\s+google_ad_section_start\s+-->(.+)<!--\s+google_ad_section_end\s+-->';

    if ( $$html_ref =~ m |$regexp|os ) {
        my $html = $1;
        my $tree = HTML::TreeBuilder::LibXML->new;
        $tree->parse($html);
        $tree->eof;
        my $text = $tree->as_text;
        $result->text($text);
        $result->{matched_engine} = 'GoogleADSection';
    }
    return $result;
}
1;
