package HTML::Feature::Engine::LDRFullFeed;
use strict;
use warnings;
use HTML::TreeBuilder::XPath;
use HTML::Feature::Result;
use LWP::Simple;
use Storable qw(retrieve store);
use JSON;
use Encode;
use Data::Dumper;
use base qw(HTML::Feature::Base);

__PACKAGE__->mk_accessors($_) for qw(_LDRFullFeed);

sub run {
    my $self     = shift;
    my $html_ref = shift;
    my $url      = shift;
    my $c        = $self->context;
    my $tree = HTML::TreeBuilder::XPath->new;
    $tree->parse($$html_ref);
    $tree->eof;
    my $site_info = $self->_detect_siteinfo($url);
    my $result    = HTML::Feature::Result->new;

    if ($site_info) {
        my $xpath = $site_info->{data}->{xpath};
        my $text;
        for my $node ( $tree->findnodes($xpath) ) {
            $text .= $node->as_text;
        }
        $result->text( $text );
        if ( my $title = $tree->look_down( _tag => "title" ) ) {
            $result->title( $title->as_text );
        }
        if ( my $desc =
            $tree->look_down( _tag => 'meta', name => 'description' ) )
        {
            $result->desc( $desc->attr("content") );
        }
    }
    if ( $result->text() ) {
        $result->{matched_engine} = 'LDRFullFeed';
    }
    return $result;
}

sub LDRFullFeed {
    my $self = shift;
    my $c    = $self->context;
    $self->_LDRFullFeed || sub {
        my $data;
        my $path = $INC{'HTML/Feature/Engine/LDRFullFeed.pm'};
        $path =~ s/.pm//;
        $path .= '/item.st';
        if ( $c->config->{LDRFullFeed}->{data_file_path} ) {
            my $path = $c->config->{LDRFullFeed}->{data_file_path};
            if ( -e $path ) {
                $data = retrieve($path);
            }
            else {
                my $json =
                  get('http://wedata.net/databases/LDRFullFeed/items.json');
                my $data = from_json($json);
                store( $path, $data );
            }
        }
        else {
            $data = retrieve($path);
        }
        my %priority = (
            SBM        => 1000,
            INDIVIDUAL => 100,
            IND        => 100,
            SUBGENERAL => 10,
            SUB        => 10,
            GENERAL    => 1,
            GEN        => 1
        );
        my @sorted = sort { $a->{data}->{priority} <=> $b->{data}->{priority} }
          map {
            $_->{data}->{priority} ||= sub {
                my $type = $_->{data}->{type};
                if ( $priority{$type} ) {
                    $_->{data}->{type} = $priority{$type};
                }
                else {
                    $_->{data}->{type} = 0;
                }
                return $_;
              }
              ->();
          } @$data;
        $self->_LDRFullFeed( \@sorted );
      }
      ->();
}

sub _detect_siteinfo {
    my $self = shift;
    my $url  = shift;
    my $data = $self->LDRFullFeed;
    for my $item (@$data) {
        if ( ( $item->{data}->{url} ) && ( $url =~ /$item->{data}->{url}/ ) ) {
            return $item;
        }
    }
    return;
}

1;
